{ config
, pkgs
, hyprMonitor
, inputs
, ...
}:


{
  dconf.settings = {

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      icon-theme = "Papirus-Dark";
    };
  };

  home.packages = with pkgs;[
    unstable.quickshell
    # DankMaterialShell
    matugen
    wl-clipboard
    cliphist
    cava
    material-symbols

    bluez
    pulseaudio
    ddcutil
    brightnessctl
    kdePackages.qtdeclarative #autocomplete
  ];

  systemd.user.services.quickshell = {
    Unit = {
      Description = "Quickshell liperium";
    };
    Service = {
      ExecStart = "${pkgs.unstable.quickshell}/bin/quickshell -c dms";
    };
  };
}
    
