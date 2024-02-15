{ config, pkgs, ... }:

{
    home.file = {
        ".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink ./.tmux.conf;
    };
    home.packages = with pkgs;[tmux];
}