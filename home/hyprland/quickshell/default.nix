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
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  systemd.user.services.quickshell = {
    Unit = {
      Description = "Noctalia-Shell autostart";
    };
    Service = {
      ExecStart = "${inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/noctalia-shell";
    };
  };
}
    
