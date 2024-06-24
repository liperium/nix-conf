{ config, pkgs, ... }:

{
  home.file = {
    ".config/helix/config.toml".source = ./config.toml;
    ".config/helix/languages.toml".source = ./languages.toml;
    ".config/helix/themes/catppuccin_mocha.toml".source = ./themes/catppuccin_mocha.toml;
  };
  home.packages = with pkgs; [
    helix

    # LSPs (Language Servers)
    zls
    rust-analyzer
    bash-language-server
    gopls

    # Formatters
    rustfmt
    nil
    nixpkgs-fmt
    shfmt
  ];
}
