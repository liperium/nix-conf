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

      # Other IDEs
      #godot_4
      blender

      # Languages - All the time on system - MAKE A SHELL DAMMIT
      #zig
      #cargo
    ];
  };
}
