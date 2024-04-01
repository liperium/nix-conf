{ config, pkgs, lib, ... }:

{
  users.users.liperium = {
    packages = with pkgs; [
      vscode
      #nixfmt 
      github-desktop
      cargo
      rust-analyzer-unwrapped
      rustup
      #godot4-mono
      godot_4
      #nodejs-slim_21
      #rustfmt
    ];
  };
}
