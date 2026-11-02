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
      runtimeInputs = [ grim slurp wl-clipboard libnotify satty coreutils ];
      text = ''
        geom=$(slurp -d)
        img=$(mktemp --suffix=.png)
        trap 'rm -f "$img"' EXIT
        grim -g "$geom" "$img"
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
