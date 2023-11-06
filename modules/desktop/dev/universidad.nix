{ config, pkgs, lib, ... }:

{
  users.users.liperium = {
    packages = with pkgs; [
      #sqldeveloper
      jetbrains.datagrip
      jetbrains.pycharm-professional
      android-studio
    ];
  };
  environment.systemPackages = with pkgs; [
    minikube
    kubectl
  ];
}
