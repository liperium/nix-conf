{ pkgs, ... }:

{
  imports = [
    ./niri-conf.nix
    ../dolphin.nix
    ../noctalia.nix
    ../hypridle
  ];

  home.packages = with pkgs; [
    brightnessctl
    niri
    satty # Screenshot edit
    # Region screenshot -> clipboard, notification "Edit" action opens satty
    (writeShellApplication {
      name = "screenshot-region";
      runtimeInputs = [ grim slurp wl-clipboard libnotify satty coreutils wayfreeze ];
      text = ''
        wayfreeze &
        freeze=$!
        img=
        trap 'kill "$freeze" 2>/dev/null; rm -f "$img"' EXIT
        sleep 0.2 # let the frozen frame appear before slurp starts
        geom=$(slurp -d)
        img=$(mktemp --suffix=.png)
        grim -g "$geom" "$img"
        kill "$freeze" # unfreeze before the notification wait
        wl-copy --type image/png < "$img"
        action=$(notify-send -a Screenshot -i "$img" -A edit=Edit --wait "Screenshot copied" || true)
        if [ "$action" = edit ]; then
          satty -f "$img" --initial-tool=arrow --copy-command=wl-copy \
            --actions-on-escape=save-to-clipboard,exit --brush-smooth-history-size=5 --disable-notifications
        fi
      '';
    })
  ];

  programs.foot = {
    enable = true;
    settings = {
      main = {
        shell = "fish";
        font = "JetBrainsMono Nerd Font:size=12";
      };
      colors-dark = {
        alpha = 0.9;
      };
    };
  };
}
