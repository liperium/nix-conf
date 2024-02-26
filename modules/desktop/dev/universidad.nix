{ config, pkgs, lib, ... }:

{
  users.users.liperium = {
    packages = with pkgs; [
      #sqldeveloper
      jetbrains.datagrip
      #jetbrains.pycharm-professional
      androidStudioPackages.canary
    ];
  };

  # TP Final Cloud
  #environment.systemPackages = with pkgs; [
    #minikube
    #kubectl
  #];
}
