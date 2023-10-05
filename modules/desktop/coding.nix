{ config, pkgs, lib, ... }:

{
  users.users.liperium = {
    packages = with pkgs; [
      vscode
      cargo
      jetbrains.pycharm-professional
    ];
  };
}