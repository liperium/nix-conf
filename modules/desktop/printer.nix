{ config, pkgs, lib, ... }:


{
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.sane-airscan ];

  # GUI scanning app
  environment.systemPackages = with pkgs; [
    simple-scan # or gscan2pdf, or both
    kdePackages.skanlite
  ];

  users.users.liperium.extraGroups = [ "scanner" "lp" ];

  # Individual Printer config
  systemd.services.ensure-printers = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };
  services.printing = {
    enable = true;
    drivers = [ ]; # empty if using pure IPP Everywhere / driverless
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  hardware.printers = {
    ensureDefaultPrinter = "ET3958";
    ensurePrinters = [
      {
        name = "ET3958";
        location = "Office";
        deviceUri = "ipp://192.168.1.73:631/ipp/print";
        model = "everywhere"; # driverless IPP Everywhere, no PPD needed
      }
    ];
  };

}
