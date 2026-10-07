{ pkgs, arcanist }:
pkgs.writeShellApplication {
  name = "arc-checkout";
  runtimeInputs = [ pkgs.git pkgs.jq arcanist ];
  text = builtins.readFile ./arc-checkout.sh;
}
