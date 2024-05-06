{ config, pkgs, ... }:

{
  imports = [
    ./hypr-conf
    ./kitty
    ./tmux
    ./zsh
    ./helix
    ./zellij
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
    # needed for ark archives
    p7zip 
    rar
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
    wl-clipboard
    firefox
    steam-run
    gparted
    vlc
    widevine-cdm
    libsForQt5.kalk

    #Theming
    papirus-icon-theme

    #Personnal
    qownnotes
    betterdiscordctl
    webcord
    discord
    vesktop

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
    kdePackages.kdenlive

    #Misc
    spot
    nextcloud-client # ? cmd
    feishin

    # Office
    onlyoffice-bin
    zoom-us

    #Theming
    (catppuccin-kvantum.override {
      accent = "Mauve";
      variant = "Mocha";
    })
    qt6Packages.qtstyleplugin-kvantum
    libsForQt5.qtstyleplugin-kvantum
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

  home.file.".config/hypr/auth.conf".text = ''
    exec-once = ${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1
    exec-once = ${pkgs.libsForQt5.kwallet-pam}/libexec/pam_kwallet_init
  '';

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
      "inode/directory" = [ "org.kde.dolphin.desktop" ];
      #"inode/directory" = ["gnome.nautilus.desktop"];
      "application/pdf" = [ "firefox.desktop" ];

      "application/gzip" = [ "org.kde.ark.desktop" ];
      "application/zip" = [ "org.kde.ark.desktop" ];
      "application/x-7z-compressed" = [ "org.kde.ark.desktop" ];
      "application/x-compressed-tar" = [ "org.kde.ark.desktop" ];

      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];

      "x-scheme-handler/x-github-client" = [ "github-desktop.desktop" ];
      "x-scheme-handler/x-github-desktop-auth" = [ "github-desktop.desktop" ];
    };
    associations.added = {
      "text/plain" = [ "Helix.desktop" ];
      "image/png" = [ "org.kde.gwenview.desktop" ];
      "image/jpeg" = [ "org.kde.gwenview.desktop" ];
    };
  };


  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
      "org/gnome/nautilus/preferences" = {
        always-use-location-entry = true; #shows dir in nautilus
      };
    };
  };
  home.pointerCursor = {
    package = pkgs.kdePackages.breeze-gtk;
    name = "breeze_cursors";
    size = 24;
  };

  qt =
    {
      enable = true;
      # disabled cause crashes KDE I think?
      #platformTheme.name = "qtct";
      #style.name = "kvantum";
    };

  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.kdePackages.breeze-gtk;
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
