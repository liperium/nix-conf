{ config
, pkgs
, lib
, ...
}:
let
  nix-flake-template = pkgs.writeShellScriptBin "nix-flake-template" ''
    #!/bin/sh
    cp ~/nix-conf/templates/simple-package-flake/flake.nix ./;
    git add flake.nix
    echo "use flake" >> .envrc && direnv allow;
  '';
in
{
  environment.systemPackages = [ nix-flake-template ];
}
