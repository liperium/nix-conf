{ config, pkgs, ... }:

{
  home.file = {
    ".config/helix/config.toml".source = ./config.toml;
    ".config/helix/languages.toml".source = ./languages.toml;
    ".config/helix/themes/catppuccin_mocha.toml".source = ./themes/catppuccin_mocha.toml;
  };
  home.sessionVariables = {
    EDITOR = "hx";
  };
  home.packages = with pkgs; [
    helix
    wl-clipboard

    # LSPs (Language Servers)
    zls
    rust-analyzer
    bash-language-server
    gopls
    taplo #toml
    yaml-language-server

    # Formatters
    rustfmt
    nil
    nixpkgs-fmt
    shfmt
  ];
}
