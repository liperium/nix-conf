{ pkgs }:
pkgs.writeShellApplication {
  name = "nix-conf-sync-check";
  runtimeInputs = [ pkgs.git pkgs.libnotify pkgs.coreutils ];
  text = builtins.readFile ./nix-conf-sync-check.sh;
}
