{ config, pkgs, ... }:

{
  imports = [
    ./hypr-conf
    ./kitty
    ./tmux
    ./zsh
  ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "liperium";
  home.homeDirectory = "/home/liperium";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs;[
    fastfetch
    dconf
    nodejs # NVChad dependency
    unzip # NVChad dependency
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    # From default config modules 
    #Basic Needs
    firefox
    steam-run
    gparted
    vlc
    widevine-cdm
    galculator

    #Theming
    beauty-line-icon-theme
    papirus-icon-theme

    #Personnal
    qownnotes
    betterdiscordctl
    webcord
    discord
    thunderbird
  
     
    qbittorrent

    #Media-Streams
    obs-studio
    chatterino2
    streamlink
    streamlink-twitch-gui-bin

    #Creative
    gimp
    kate
    krita
    libsForQt5.kdenlive

    #Misc
    spot
    nextcloud-client # ? cmd
    via

    # Office
    onlyoffice-bin
    zoom-us
  ];
  #Direnv
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/liperium/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      #"inode/directory" = ["gnome.thunar.desktop"];
      "inode/directory" = ["gnome.nautilus.desktop"];
      "application/pdf" = ["firefox.desktop"];

      "application/gzip" = ["org.gnome.FileRoller.desktop"];
      "application/zip" = ["org.gnome.FileRoller.desktop"];
      "application/x-7z-compressed" = ["org.gnome.FileRoller.desktop"];
      "application/x-compressed-tar" = ["org.gnome.FileRoller.desktop"];

      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];

      "x-scheme-handler/x-github-client" = ["github-desktop.desktop"];
      "x-scheme-handler/x-github-desktop-auth" = ["github-desktop.desktop"];
    };
    associations.added = {
      "text/plain" = ["org.kde.kate.desktop"];
    };
  };


  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"]  ;
        uris = ["qemu:///system"];
      };
      "org/gnome/nautilus/preferences" = {
        always-use-location-entry= true; #shows dir in nautilus
      };
    };        
  };
  home.pointerCursor = {
    package = pkgs.libsForQt5.breeze-gtk;
    name = "breeze_cursors";
    size = 24;
  };

  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.libsForQt5.breeze-gtk;
      name = "breeze_cursors";
      size = 24;
    };
    theme = {
      name = "Catppuccin-Mocha-Standard-Mauve-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
        variant = "mocha"; # Since gtk are applications, I like Mocha for apps and Macchiato for OS
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "Noto Sans";
      package = pkgs.noto-fonts;
      size = 12;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
