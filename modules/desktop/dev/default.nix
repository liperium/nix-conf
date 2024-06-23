{ config
, pkgs
, lib
, ...
}:

{
  users.users.liperium = {
    packages = with pkgs; [
      vscode
      github-desktop
      godot_4

      gh
      # Languages - All the time on system - MAKE A SHELL DAMMIT
      zig

      # Language servers
      zls
    ];
  };
}
