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
    quickshell
    jq
    fd
    (pkgs.python3.withPackages (python-pkgs: with python-pkgs; [
      # select Python packages here
      aubio
      pyaudio
      numpy
    ]))
    cava
    bluez
    pulseaudio
    ddcutil
    brightnessctl
    curl
    material-symbols
    kdePackages.qtdeclarative #autocomplete
    lm_sensors
  ];

  systemd.user.services.quickshell = {
    Unit = {
      Description = "Quickshell caelestia";
    };
    Service = {
      ExecStart = "${pkgs.quickshell}/bin/quickshell -c caelestia";
    };
  };
}
    
