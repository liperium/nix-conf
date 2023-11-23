{ config, pkgs, lib, ... }:
let
  conservationmode = pkgs.writeShellScriptBin "nix-quick-update" ''
    #!/bin/sh
    git stash && git pull && sudo nixos-rebuild switch --flake /home/liperium/nix-conf && git stash pop
  '';
in {
  environment.systemPackages = [ nix-quick-update ];
}
