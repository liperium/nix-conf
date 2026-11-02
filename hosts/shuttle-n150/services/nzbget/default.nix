{ pkgs, config, ... }:
{
  services.nzbget = {
    enable = true;
    group = "users";
    settings = {
      ControlPort = 6789;
      MainDir = "/zfs-data/nzb";
    };
  };
  # Download root; not auto-created by the module or the /zfs-data
  # pool itself (ZFS-mounted, no Nix-managed ownership).
  systemd.tmpfiles.rules = [
    "d /zfs-data/nzb 0775 nzbget users -"
  ];
  # Runs inside the qvpn namespace (../vpn-namespace).
  systemd.services.nzbget = {
    vpnConfinement = {
      enable = true;
      vpnNamespace = "qvpn";
    };
    after = [ "qvpn.service" ];
    requires = [ "qvpn.service" ];
  };
}
