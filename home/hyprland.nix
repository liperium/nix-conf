{ config, pkgs, ... }:


{
  imports = [
    # Desktop
    ./desktop.nix
    ./console.nix

    ./hypr-conf
    ./kitty
  ];
}
