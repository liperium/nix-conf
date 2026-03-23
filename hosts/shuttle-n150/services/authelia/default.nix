{ pkgs, ... }:
{
  services.authelia.instances.main = {
    enable = true;
    secrets = {
      jwtSecretFile = "/run/secrets/authelia/jwt";
      storageEncryptionKeyFile = "/run/secrets/authelia/storage";
      sessionSecretFile = "/run/secrets/authelia/session";
    };
    settings = {
      theme = "dark";
      default_2fa_method = "totp";

      server = {
        address = "tcp://127.0.0.1:9091";
      };

      log = {
        level = "info";
        format = "text";
      };

      authentication_backend = {
        file = {
          path = "/run/secrets/authelia/users";
          password = {
            algorithm = "argon2";
            argon2 = {
              variant = "argon2id";
              iterations = 3;
              memory = 65536;
              parallelism = 4;
              key_length = 32;
              salt_length = 16;
            };
          };
        };
      };

      access_control = {
        default_policy = "deny";
        rules = [
          {
            domain = "mtg.mattysgervais.com";
            policy = "one_factor";
          }
          {
            domain = "pdf.mattysgervais.com";
            policy = "one_factor";
          }
          {
            domain = "convertx.mattysgervais.com";
            policy = "one_factor";
          }
          {
            domain = "auth.mattysgervais.com";
            policy = "bypass";
          }
        ];
      };

      session = {
        name = "authelia_session";
        cookies = [
          {
            domain = "mattysgervais.com";
            authelia_url = "https://auth.mattysgervais.com";
            default_redirection_url = "https://mtg.mattysgervais.com";
          }
        ];
      };

      storage = {
        local = {
          path = "/var/lib/authelia-main/db.sqlite3";
        };
      };

      notifier = {
        filesystem = {
          filename = "/var/lib/authelia-main/notifications.txt";
        };
      };
    };
  };

  sops.secrets."authelia/users" = {
    sopsFile = ../../../../modules/secrets/authelia-users.yml;
    format = "binary";
    owner = "authelia-main";
  };
  sops.secrets."authelia/jwt" = {
    sopsFile = ../../../../modules/secrets/authelia.yaml;
    key = "jwt_secret";
    owner = "authelia-main";
  };
  sops.secrets."authelia/storage" = {
    sopsFile = ../../../../modules/secrets/authelia.yaml;
    key = "storage_encryption_key";
    owner = "authelia-main";
  };
  sops.secrets."authelia/session" = {
    sopsFile = ../../../../modules/secrets/authelia.yaml;
    key = "session_secret";
    owner = "authelia-main";
  };
}
