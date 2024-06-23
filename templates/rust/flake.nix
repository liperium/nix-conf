{
  description = "Basic Rust template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , utils
    ,
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        packageName = "rust-package";
        pkgs = nixpkgs.legacyPackages.${system};
        shellInputs = with pkgs; [
          cargo
        ];
        appNativeBuildInputs = with pkgs; [ pkg-config ];
        appRuntimeInputs = with pkgs; [

        ];
        appBuildInputs =
          appRuntimeInputs
          ++ (with pkgs; [

          ]);
      in
      {
        devShells.${packageName} = pkgs.mkShell {
          nativeBuildInputs = appNativeBuildInputs;
          buildInputs = shellInputs ++ appBuildInputs;
          shellHook = ''
            export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath appRuntimeInputs}"
          '';
        };
        devShell = self.devShells.${system}.${packageName};
      }
    );
}

