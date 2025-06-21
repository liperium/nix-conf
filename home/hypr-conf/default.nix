{ config, pkgs, hyprMonitor, ... }:
{
  imports = [
    ./rofi
    ./hypr
    #./waybar
    #./mako
    #./wlogout
    #./hyprpanel
    #./hyprpaper hyprpanel has background support
  ];
  # home.file.".config/hypr/auth.conf".text = ''
  #   exec-once = ${pkgs.gnome-keyring}/libexec/polkit-kde-authentication-agent-1      
  # '';
  # exec-once = ${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1
  #     exec-once = ${pkgs.libsForQt5.kwallet-pam}/libexec/pam_kwallet_init
}
