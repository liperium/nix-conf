{ config
, pkgs
, hyprMonitor
, inputs
, ...
}:


{
  imports = [
    # Desktop
    ./desktop.nix
    ./console.nix

    ./hypr-conf

  ];
  dconf.settings = {

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      icon-theme = "Papirus-Dark";
    };
  };

  home.packages = with pkgs;[
    quickshell
    fish
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
    
