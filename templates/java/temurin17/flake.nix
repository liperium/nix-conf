{
  description = "Basic openjdk flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs =
    { self, nixpkgs }:
    {
      devShell.x86_64-linux =
        with nixpkgs.legacyPackages.x86_64-linux;
        mkShell { buildInputs = [ temurin-bin-17 ]; };
    };
}
