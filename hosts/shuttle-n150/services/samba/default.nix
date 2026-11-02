{ ... }:
{
  users.users.marie = {
    isNormalUser = true;
    group = "users";
    home = "/zfs-data/marie";
    createHome = true;
  };

  # Samba - need to setup a user for the private share
  # sudo smbpasswd -a myuser
  services.samba = {
    enable = true;

    openFirewall = true;
    settings = {
      global = {
        security = "user";
        "workgroup" = "WORKGROUP";
        "server string" = "shuttle-n150";
        "netbios name" = "shuttle-n150";
        "hosts allow" = "192.168.0. 192.168.1. 10.0.0. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
      private = {
        path = "/zfs-data";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "writeable" = "yes";
        "inherit permissions" = "yes";
      };
      marie = {
        path = "/zfs-data/marie";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "writeable" = "yes";
        "valid users" = "marie";
        "force user" = "marie";
        "force group" = "users";
        "create mask" = "0664";
        "directory mask" = "0775";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };
}
