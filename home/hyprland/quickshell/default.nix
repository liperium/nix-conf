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

  programs.noctalia-shell = {
    enable = true;
    plugins = {
      sources = [
        {
          enabled = true;
          name = "Official Noctalia Plugins";
          url = "https://github.com/noctalia-dev/noctalia-plugins";
        }
      ];
      states = {
        screen-toolkit = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
      };
      version = 2;
    };
  };



  home.packages = with pkgs;[
    unstable.quickshell
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default

    #Screen-Toolkit dependencies
    grim
    slurp
    wl-clipboard
    tesseract4
    imagemagick
    zbar
    translate-shell
    wf-recorder
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
    
