{ config, pkgs, ... }:

{
    home.file = {
        ".zshrc".source = config.lib.file.mkOutOfStoreSymlink ./.zshrc;
        ".p10k.zsh".source = config.lib.file.mkOutOfStoreSymlink ./.p10k.zsh;
    };
    home.packages = with pkgs;[zsh zsh-powerlevel10k];
}