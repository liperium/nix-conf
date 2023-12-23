{ config, pkgs, lib, ... }:

{
  users.users.liperium = { packages = with pkgs; [ 
    vscode 
    #nixfmt 
    github-desktop
    cargo 
    rust-analyzer-unwrapped
    rustup
    #nodejs-slim_21
    #rustfmt
    ]; 
    };
}
