{
  config,
  pkgs,
  lib,
  ...
}:
let
  conservationmode = pkgs.writeShellScriptBin "conservationmode" ''
    #!/bin/sh
    echo $((RANDOM % 2))
  '';
in
{
  environment.systemPackages = [ conservationmode ];

  security.sudo = {
    enable = true;
    extraRules = [
      {
        commands = [
          {
            command = "/run/current-system/sw/bin/conservationmode";
            options = [ "NOPASSWD" ];
          }
        ];
        groups = [ "wheel" ];
      }
    ];
  };
}
