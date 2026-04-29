{ pkgs, ... }:

{
  xdg.configFile."niri/config.kdl".text = ''
    input {
        keyboard {
            xkb {
                layout "us"
                variant "alt-intl"
            }
            numlock
        }
        mouse {
            // natural-scroll disabled on desktop
        }
        touchpad {
            natural-scroll
            tap
        }
        warp-mouse-to-focus
        focus-follows-mouse
    }

    output "eDP-1" {
        scale 1.25
    }

    output "DP-1" {
        mode "2560x1440@239.970"
        scale 1.25
    }

    output "DP-2" {
        mode "2560x1440@164.802"
        scale 1.25
    }

    layout {
        gaps 8

        focus-ring {
            off
        }

        border {
            on
            width 2
            active-color "#b7bdf8"
            inactive-color "#6e738d"
        }
    }

    // Corner radius for all windows
    window-rule {
        geometry-corner-radius 8
        clip-to-geometry true
    }

    prefer-no-csd

    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    environment {
        XCURSOR_SIZE "24"
        QT_QPA_PLATFORM "wayland"
        QT_QPA_PLATFORMTHEME "qt6ct"
        QT_WAYLAND_DISABLE_WINDOWDECORATION "1"
        QT_AUTO_SCREEN_SCALE_FACTOR "1"
        NIXOS_OZONE_WL "1"
        XDG_DATA_DIRS "/etc/profiles/per-user/$USER/share:/run/current-system/sw/share:$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share"
    }

    spawn-at-startup "gnome-keyring-daemon" "--start" "--components=secrets"
    spawn-at-startup "systemctl" "--user" "start" "quickshell"
    spawn-at-startup "systemctl" "--user" "start" "hypridle"
    spawn-at-startup "nextcloud" "--background"
    spawn-at-startup "discord" "--start-minimized"
    spawn-at-startup "tailscale" "systray"

    binds {
        // Media keys
        XF86AudioRaiseVolume { spawn "noctalia-shell" "ipc" "call" "volume" "increase"; }
        XF86AudioLowerVolume { spawn "noctalia-shell" "ipc" "call" "volume" "decrease"; }
        XF86AudioMicMute     { spawn "noctalia-shell" "ipc" "call" "volume" "muteInput"; }
        XF86AudioMute        { spawn "noctalia-shell" "ipc" "call" "volume" "muteOutput"; }
        XF86AudioPlay        { spawn "noctalia-shell" "ipc" "call" "media" "playPause"; }
        XF86AudioPause       { spawn "noctalia-shell" "ipc" "call" "media" "playPause"; }
        XF86AudioNext        { spawn "noctalia-shell" "ipc" "call" "media" "next"; }
        XF86AudioPrev        { spawn "noctalia-shell" "ipc" "call" "media" "previous"; }
        XF86MonBrightnessUp   { spawn "brightnessctl" "s" "+5%"; }
        XF86MonBrightnessDown { spawn "brightnessctl" "s" "5%-"; }

        // Window management
        Mod+C   { close-window; }
        Mod+M   { quit; }
        Mod+V   { toggle-window-floating; }
        Mod+F   { fullscreen-window; }
        Mod+Tab { focus-column-right; }

        // Focus
        Mod+Left  { focus-column-left; }
        Mod+Right { focus-column-right; }
        Mod+Up    { focus-window-up; }
        Mod+Down  { focus-window-down; }

        // Wheel Scroll defaults niri
        Mod+Shift+WheelScrollDown      { focus-column-right; }
        Mod+Shift+WheelScrollUp        { focus-column-left; }
        Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
        Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }
        Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
        Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
        Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
        Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

        // Move
        Mod+Shift+Left  { move-column-left; }
        Mod+Shift+Right { move-column-right; }
        Mod+Shift+Up    { move-window-up; }
        Mod+Shift+Down  { move-window-down; }

        // Workspaces
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }

        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }
        Mod+Shift+7 { move-column-to-workspace 7; }

        // Apps
        Mod+Q { spawn "foot"; }
        Mod+E { spawn "sh" "-c" "XDG_CURRENT_DESKTOP=kde dolphin"; }
        Mod+S { spawn "noctalia-shell" "ipc" "call" "launcher" "toggle"; }

        // Screenshots: region to clipboard / region to file
        Print       { spawn "sh" "-c" "grim -g \"$(slurp)\" - | wl-copy"; }
        Shift+Print { spawn "sh" "-c" "mkdir -p ~/Pictures/Screenshots && grim -g \"$(slurp)\" ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"; }
    }
  '';
}
