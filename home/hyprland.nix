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
    #./kitty
  ];
  dconf.settings = {

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      icon-theme = "Papirus-Dark";
    };
  };

  home.packages = with pkgs;[
    # Pactl for f keys
    pulseaudio
    wezterm

    # Quickshell caelestial test
    inputs.quickshell.packages.x86_64-linux.default
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
      ExecStart = "${inputs.quickshell.packages.x86_64-linux.default}/bin/quickshell -c caelestia";
    };
  };
}
