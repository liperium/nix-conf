{ config, pkgs, ... }:


{
  dconf = {
    enable = true; # needed for theming
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
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
        hint-color-rgba = "rgba(203, 166, 247, 1)";
      };
      "org/gnome/mutter" = {
        experimental-features = "['scale-monitor-framebuffer']";
      };
      "org/gnome/nautilus/preferences" = {
        always-use-location-entry = true;
      };
    };
  };
}
