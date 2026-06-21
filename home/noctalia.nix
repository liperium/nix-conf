{ pkgs, inputs, ... }:

{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      icon-theme = "Papirus-Dark";
    };
  };

  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };

  home.packages = with pkgs; [
    # Screen-Toolkit plugin dependencies
    grim
    slurp
    wl-clipboard
    (pkgs.tesseract4.override { enableLanguages = [ "eng" "fra" "spa" ]; })
    imagemagick
    zbar
    translate-shell
    wf-recorder
  ];
}
