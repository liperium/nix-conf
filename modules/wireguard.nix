{
  config,
  pkgs,
  lib,
  ...
}:

{
  services.resolved.enable = true;
  environment.systemPackages = with pkgs; [ wireguard-tools ];
}
