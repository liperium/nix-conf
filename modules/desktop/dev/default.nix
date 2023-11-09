{ config, pkgs, lib, ... }:

{
  users.users.liperium = { packages = with pkgs; [ 
    vscode 
    nixfmt 
    cargo 
    rust-analyzer 
    rustfmt
    ]; 
    };
}
