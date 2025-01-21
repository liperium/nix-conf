{ config, pkgs, lib, ... }:


{
  imports = [
    # Desktop
    ./desktop.nix
    ./console.nix

    ./kitty
  ];

  dconf.settings = {
    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///home/liperium/nix-conf/home/assets/backgrounds/shaded_landscape.jpg";
      picture-uri-dark = "file:///home/liperium/nix-conf/home/assets/backgrounds/shaded_landscape.jpg";
      primary-color = "#000000000000";
      secondary-color = "#000000000000";
    };

    "org/gnome/desktop/input-sources" = {
      sources = [ (lib.gvariant.mkTuple [ "xkb" "us+alt-intl" ]) ];
      xkb-options = [ "terminate:ctrl_alt_bksp" ];
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      icon-theme = "Papirus-Dark";
      show-battery-percentage = false;
      text-scaling-factor = 1.25;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      click-method = "areas";
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/screensaver" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///home/liperium/nix-conf/home/assets/backgrounds/shaded_landscape.jpg";
      primary-color = "#000000000000";
      secondary-color = "#000000000000";
    };
    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>c" ];
      move-to-workspace-1 = [ "<Shift><Super>1" ];
      move-to-workspace-2 = [ "<Shift><Super>2" ];
      move-to-workspace-3 = [ "<Shift><Super>3" ];
      move-to-workspace-4 = [ "<Shift><Super>4" ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      toggle-fullscreen = [ "<Super>f" ];
    };

    "org/gnome/desktop/wm/preferences" = {
      focus-mode = "sloppy";
    };
    "org/gnome/mutter" = {
      edge-tiling = false;
    };

    "org/gnome/nautilus/preferences" = {
      always-use-location-entry = true;
      default-folder-viewer = "icon-view";
      migrated-gtk-settings = true;
      search-filter-time-type = "last_modified";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>q";
      command = "kitty";
      name = "kitty";
    };
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = with pkgs.gnomeExtensions; [
        pop-shell.extensionUuid
        user-themes.extensionUuid
        appindicator.extensionUuid
        clipboard-history.extensionUuid
      ];
    };

    "org/gnome/shell/extensions/pop-shell" = {
      active-hint = true;
      hint-color-rgba = "rgba(203, 166, 247, 1)";
      tile-by-default = true;
    };

    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [ ];
      switch-to-application-2 = [ ];
      switch-to-application-3 = [ ];
      switch-to-application-4 = [ ];
      toggle-quick-settings = [ ];
    };

    "org/gnome/tweaks" = {
      show-extensions-notice = false;
    };

    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };

  };
}
