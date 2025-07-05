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
      claude-code
      github-desktop
      gh

      # Other IDEs
      godot_4
      blender

      # Languages - All the time on system - MAKE A SHELL DAMMIT
      zig
      cargo
    ];
  };
}
