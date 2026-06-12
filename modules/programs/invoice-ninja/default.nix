# InvoiceNinja docker stack (mysql + redis + php-fpm app).
# The host's Caddy serves static files from ${dataDir}/public and proxies
# PHP via FastCGI to the app container's php-fpm exposed on 127.0.0.1.
# Requires: sops-nix and virtualisation.docker (see modules/docker.nix).
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.invoice-ninja;

  image = "${cfg.image}:${cfg.imageTag}";

  secretPath = config.sops.secrets."invoice-ninja.env".path;

  dataDir = cfg.dataDir;
  network = "invoice-ninja";
in
{
  options.services.invoice-ninja = {
    enable = lib.mkEnableOption "InvoiceNinja docker stack";

    fastcgiPort = lib.mkOption {
      type = lib.types.port;
      default = 9000;
      description = "Host-side port (bound to 127.0.0.1) forwarded to the app container's php-fpm.";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/invoice-ninja";
      description = "Persistent state directory for public, storage, mysql and redis data.";
    };

    image = lib.mkOption {
      type = lib.types.str;
      default = "invoiceninja/invoiceninja-debian";
      description = "InvoiceNinja application image (without tag).";
    };

    imageTag = lib.mkOption {
      type = lib.types.str;
      default = "latest";
      description = "InvoiceNinja image tag.";
    };

    secretsFile = lib.mkOption {
      type = lib.types.path;
      description = "Sops-encrypted dotenv file (see invoice-ninja.env.example).";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker.enable = lib.mkDefault true;

    sops.secrets."invoice-ninja.env" = {
      sopsFile = cfg.secretsFile;
      format = "dotenv";
      restartUnits = [
        "docker-invoice-ninja-app.service"
        "docker-invoice-ninja-mysql.service"
      ];
    };

    systemd.tmpfiles.rules = [
      "d ${dataDir} 0755 root root -"
      "d ${dataDir}/public 0755 root root -"
      "d ${dataDir}/storage 0755 root root -"
      "d ${dataDir}/mysql 0755 root root -"
      "d ${dataDir}/redis 0755 root root -"
    ];

    # Custom docker network so containers can resolve each other by name.
    # The default bridge does not provide inter-container DNS.
    systemd.services.invoice-ninja-network = {
      description = "Create invoice-ninja docker network";
      after = [ "docker.service" "docker.socket" ];
      requires = [ "docker.service" "docker.socket" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        ${pkgs.docker}/bin/docker network inspect ${network} >/dev/null 2>&1 || \
          ${pkgs.docker}/bin/docker network create ${network}
      '';
    };

    virtualisation.oci-containers = {
      backend = "docker";

      containers = {
        invoice-ninja-mysql = {
          image = "docker.io/library/mysql:8";
          autoStart = true;
          environmentFiles = [ secretPath ];
          volumes = [ "${dataDir}/mysql:/var/lib/mysql" ];
          extraOptions = [
            "--network=${network}"
            "--health-cmd=mysqladmin ping -h localhost -u$${MYSQL_USER} -p$${MYSQL_PASSWORD}"
            "--health-interval=10s"
            "--health-timeout=5s"
            "--health-retries=5"
            "--health-start-period=30s"
          ];
        };

        invoice-ninja-redis = {
          image = "docker.io/library/redis:alpine";
          autoStart = true;
          volumes = [ "${dataDir}/redis:/data" ];
          extraOptions = [
            "--network=${network}"
            "--health-cmd=redis-cli ping"
            "--health-interval=10s"
            "--health-timeout=5s"
            "--health-retries=5"
            "--health-start-period=10s"
          ];
        };

        invoice-ninja-app = {
          image = image;
          autoStart = true;
          dependsOn = [ "invoice-ninja-mysql" "invoice-ninja-redis" ];
          environmentFiles = [ secretPath ];
          ports = [ "127.0.0.1:${toString cfg.fastcgiPort}:9000" ];
          volumes = [
            "${dataDir}/public:/var/www/html/public"
            "${dataDir}/storage:/var/www/html/storage"
          ];
          extraOptions = [
            "--network=${network}"
            "--health-cmd=REMOTE_ADDR=127.0.0.1 REQUEST_URI=/health REQUEST_METHOD=GET SCRIPT_FILENAME=/var/www/html/public/index.php cgi-fcgi -bind -connect 127.0.0.1:9000 | grep '{\"status\":\"ok\",\"message\":\"API is healthy\"}'"
            "--health-start-period=100s"
            "--health-interval=30s"
            "--health-timeout=10s"
            "--health-retries=5"
          ];
        };
      };
    };

    # Make every container wait for the custom network to exist.
    systemd.services.docker-invoice-ninja-mysql.after = [ "invoice-ninja-network.service" ];
    systemd.services.docker-invoice-ninja-mysql.requires = [ "invoice-ninja-network.service" ];
    systemd.services.docker-invoice-ninja-redis.after = [ "invoice-ninja-network.service" ];
    systemd.services.docker-invoice-ninja-redis.requires = [ "invoice-ninja-network.service" ];
    systemd.services.docker-invoice-ninja-app.after = [ "invoice-ninja-network.service" ];
    systemd.services.docker-invoice-ninja-app.requires = [ "invoice-ninja-network.service" ];
  };
}
