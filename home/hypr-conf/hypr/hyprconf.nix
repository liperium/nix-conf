{ config, lib, pkgs, hyprMonitor, ... }:

let
  # Define host-specific monitor configurations
  primaryMonitor = hyprMonitor.primary or "DP-1";
  secondaryMonitor = hyprMonitor.secondary or "DP-2";
  monitorSettings = hyprMonitor.settings or [
    "DP-1,preferred,auto,1"
    ",preferred,auto,1"
  ];
  # Helper function to assign workspaces to monitors
  assignWorkspaces = primary: secondary: [
    "1, persistent:true, default:true, monitor:${primary}"
    "2, on-created-empty:[tiled] firefox, monitor:${secondary}"
    "3, on-created-empty:[tiled] discord, monitor:${secondary}"
    "4, on-created-empty:[tiled] kitty hx /home/liperium/nix-conf, monitor:${primary}"
    "5, on-created-empty:[tiled] steam, monitor:${primary}"
  ];
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = monitorSettings;

      source = [ "./macchiato.conf" ];

      env = [
        "XCURSOR_SIZE,24"
        "WLR_NO_HARDWARE_CURSORS,1"
        "QT_QPA_PLATFORM,wayland"
        "QT_QPA_PLATFORMTHEME,qt5ct"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "HYPRSHOT_DIR,/home/liperium/Pictures/hyprshot"
      ];

      blurls = [ "waybar" ];

      input = {
        kb_layout = "us";
        kb_variant = "alt-intl";
        kb_model = "";
        kb_options = "";
        kb_rules = "";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
        };
        sensitivity = 0;
        numlock_by_default = true;
      };

      xwayland = {
        force_zero_scaling = true;
      };

      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 2;
        "col.active_border" = "$lavender";
        "col.inactive_border" = "$overlay0";
        layout = "dwindle";
      };

      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size = 5;
          passes = 1;
          new_optimizations = "on";
        };
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, default, slide"
          "windowsOut, 1, 7, default, slide"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      gestures = {
        workspace_swipe = true;
      };

      "$mainMod" = "SUPER";

      bind = [
        ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
        ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
        ", XF86AudioMicMute, exec, pactl set-source-mute @DEFAULT_SOURCE@ toggle"
        ", XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86MonBrightnessUp, exec, brightnessctl s +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"

        "$mainMod, C, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, V, togglefloating,"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"

        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"

        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        # Apps
        "$mainMod, Q, exec, kitty"
        "$mainMod, E, exec, pcmanfm-qt"

        # Rofi menu
        "$mainMod, S, exec, rofi -modes \"run,drun\" -show drun -show-icons"
        "$mainMod SHIFT, S, exec, killall rofi"

        # Reloads
        "$mainMod SHIFT, B, exec, ~/.config/hypr/scripts/waybar/start.sh"

        # Fullscreen
        "$mainMod, F, fullscreen"
        "$mainMod, Tab, cyclenext"

        # Screenshot
        ", print, exec, hyprshot -m region --clipboard-only"
        "SHIFT, print, exec, hyprshot -m region"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      "exec-once" = [
        "gnome-keyring-daemon --start --components=secrets"
        "systemctl --user start hyprpolkitagent"
        #"hyprpanel"
        "qs -c caelestia"
        #"hyprpaper"
        #"xembedsniproxy"
        "sleep 1.0 && nextcloud --background"
        "[workspace 3 silent] sleep 3.0 && discord --start-minimized"
      ];

      workspace = assignWorkspaces primaryMonitor secondaryMonitor;

      windowrulev2 = [
        "stayfocused, title:^()$,class:^(steam)$"
        "float,class:^(pavucontrol)$"
        "move 55% 42,class:^(pavucontrol)$"
        "noanim,class:^(pavucontrol)$"
        "size 45% 50%,class:^(pavucontrol)$"
        "float,title:(Nextcloud)"
        "move 55% 42,title:(Nextcloud)"
        "noanim,title:(Nextcloud)"
        "size 45% 50%,title:(Nextcloud)"
      ];
    };
  };
}
