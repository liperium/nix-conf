# InvoiceNinja stack (docker-compose equivalent) for NixOS.
#
# Copy the whole nixos/ directory into your flake, e.g.:
#
#   nix-conf/modules/services/ml-ninja/
#     default.nix          <- rename ml-ninja.nix to default.nix
#     nginx/
#     ml-ninja.env.example
#
# Then import from the host:
#
#   imports = [ ../../modules/services/ml-ninja ];
#
# Create and encrypt secrets (from your nix-conf root):
#
#   cp path/to/ml-ninja.env.example modules/secrets/ml-ninja.env
#   sops --config ./.sops.yaml encrypt --input-type dotenv --in-place ./modules/secrets/ml-ninja.env
#
# Requires: sops-nix module, virtualisation.docker (see modules/docker.nix).
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.ml-ninja;

  image = "${cfg.image}:${cfg.imageTag}";

  nginxConfigDir = pkgs.runCommand "ml-ninja-nginx-conf" { } ''
    mkdir -p $out
    cp ${./nginx/invoiceninja.conf} $out/
    cp ${./nginx/laravel.conf} $out/
  '';

  secretPath = config.sops.secrets."ml-ninja.env".path;

  dataDir = cfg.dataDir;
in
{
  options.services.ml-ninja = {
    enable = lib.mkEnableOption "InvoiceNinja (ml-ninja) docker stack";

    port = lib.mkOption {
      type = lib.types.port;
      default = 8012;
      description = "Host port mapped to nginx.";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/ml-ninja";
      description = "Persistent state directory for public, storage, mysql, and redis data.";
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
      description = ''
        Sops-encrypted dotenv file. When this module lives at
        modules/services/ml-ninja.nix, use ../secrets/ml-ninja.env.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker.enable = lib.mkDefault true;

    sops.secrets."ml-ninja.env" = {
      sopsFile = cfg.secretsFile;
      format = "dotenv";
      restartUnits = [
        "docker-app.service"
        "docker-mysql.service"
      ];
    };

    systemd.tmpfiles.rules = [
      "d ${dataDir} 0755 root root -"
      "d ${dataDir}/public 0755 root root -"
      "d ${dataDir}/storage 0755 root root -"
      "d ${dataDir}/mysql 0755 root root -"
      "d ${dataDir}/redis 0755 root root -"
    ];

    virtualisation.oci-containers = {
      backend = "docker";

      containers = {
        mysql = {
          image = "docker.io/library/mysql:8";
          autoStart = true;
          environmentFiles = [ secretPath ];
          volumes = [
            "${dataDir}/mysql:/var/lib/mysql"
          ];
          extraOptions = [
            "--health-cmd=mysqladmin ping -h localhost -u$${MYSQL_USER} -p$${MYSQL_PASSWORD}"
            "--health-interval=10s"
            "--health-timeout=5s"
            "--health-retries=5"
            "--health-start-period=30s"
          ];
        };

        redis = {
          image = "docker.io/library/redis:alpine";
          autoStart = true;
          volumes = [
            "${dataDir}/redis:/data"
          ];
          extraOptions = [
            "--health-cmd=redis-cli ping"
            "--health-interval=10s"
            "--health-timeout=5s"
            "--health-retries=5"
            "--health-start-period=10s"
          ];
        };

        app = {
          image = image;
          autoStart = true;
          dependsOn = [
            "mysql"
            "redis"
          ];
          environmentFiles = [ secretPath ];
          volumes = [
            "${dataDir}/public:/var/www/html/public"
            "${dataDir}/storage:/var/www/html/storage"
          ];
          extraOptions = [
            "--health-cmd=REMOTE_ADDR=127.0.0.1 REQUEST_URI=/health REQUEST_METHOD=GET SCRIPT_FILENAME=/var/www/html/public/index.php cgi-fcgi -bind -connect 127.0.0.1:9000 | grep '{\"status\":\"ok\",\"message\":\"API is healthy\"}'"
            "--health-start-period=100s"
            "--health-interval=30s"
            "--health-timeout=10s"
            "--health-retries=5"
          ];
        };

        nginx = {
          image = "docker.io/library/nginx:alpine";
          autoStart = true;
          dependsOn = [ "app" ];
          ports = [
            "${toString cfg.port}:80"
          ];
          volumes = [
            "${nginxConfigDir}:/etc/nginx/conf.d:ro"
            "${dataDir}/public:/var/www/html/public:ro"
            "${dataDir}/storage:/var/www/html/storage:ro"
          ];
        };
      };
    };
  };
}
