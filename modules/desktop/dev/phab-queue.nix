{ pkgs, arcanist }:
pkgs.writeShellApplication {
  name = "phab-queue";
  runtimeInputs = [ pkgs.jq arcanist ];
  text = builtins.readFile ./phab-queue.sh;
}
