{ config, pkgs, lib, ... }:
let
  godot4-mono = pkgs.callPackage ./godot4-mono/default.nix { };
in
{
  users.users.liperium = {
    packages = with pkgs; [ steam-run dotnet-sdk jetbrains.rider godot4-mono ];
  };
}
