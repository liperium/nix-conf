{ config, pkgs, ... }:

{
  home.file = {
    ".config/hypr/hypridle.conf".text = ''
      general {
        #lock_cmd = notify-send "lock!"          # dbus/sysd lock command (loginctl lock-session)
        #unlock_cmd = notify-send "unlock!"      # same as above, but unlock
        #before_sleep_cmd = notify-send "Zzz"    # command ran before sleep
        #after_sleep_cmd = notify-send "Awake!"  # command ran after sleep
        ignore_dbus_inhibit = false             # whether to ignore dbus-sent idle-inhibit requests (used by e.g. firefox or steam)
        ignore_systemd_inhibit = false          # whether to ignore systemd-inhibit --what=idle inhibitors
      }

      listener {
          timeout = 60
          on-timeout = brightnessctl -s && brightnessctl s 1%
          on-resume = brightnessctl -r 
      }
      listener {
        timeout = 300
        on-timeout = systemctl suspend
      }
    '';
  };

  home.packages = with pkgs; [
    hypridle
  ];
}
