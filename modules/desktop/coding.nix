{ config, pkgs, lib, ... }:

{
  users.users.liperium = {
    packages = with pkgs; [
      vscode
      jetbrains.pycharm-professional
    ];
  };
}