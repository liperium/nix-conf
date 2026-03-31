{ inputs, pkgs, ... }:
{
  # Create symlink for Caddy to serve ml-production-website
  systemd.tmpfiles.rules = [
    "L+ /var/lib/ml-production-website - - - - ${inputs.ml-production-website.packages.${pkgs.system}.default}"
  ];
}
