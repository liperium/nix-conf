{ config
, pkgs
, lib
, ...
}:

{
  users.users.liperium = {
    packages = with pkgs; [
      # General
      unstable.arcanist
      unstable.devenv
    ];
  };
}
