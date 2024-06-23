{ config
, pkgs
, lib
, ...
}:

{
  users.users.liperium = {
    packages = with pkgs; [
      # General
      vscode
      github-desktop
      gh

      # Other IDEs
      godot_4

      # Languages - All the time on system - MAKE A SHELL DAMMIT
      zig

    ];
  };
}
