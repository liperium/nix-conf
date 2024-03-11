{
  description = "Basic Bevy template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    naersk.url = "github:nmattia/naersk";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, naersk, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        packageName = "mygame";
        pkgs = nixpkgs.legacyPackages.${system};
        shellInputs = with pkgs; [
          cargo
          clang
          rustc
        ];
        appNativeBuildInputs = with pkgs; [
          pkg-config
        ];
        appBuildInputs = appRuntimeInputs ++ (with pkgs; [
          alsaLib
          udev
          vulkan-headers
          vulkan-tools
          vulkan-validation-layers
          xorg.libX11
          wayland
        ]);
        appRuntimeInputs = with pkgs; [
          vulkan-loader
          xorg.libXcursor 
          xorg.libXi 
          xorg.libXrandr
        ];
      in {
        packages.${packageName} = naersk.lib.${system}.buildPackage {
          pname = packageName;
          root = ./.;
          nativeBuildInputs = appNativeBuildInputs;
          buildInputs = appBuildInputs;
        };
        defaultPackage = self.packages.${packageName};

        apps.${packageName} = utils.lib.mkApp {
          drv = self.packages.${packageName};
        };
        defaultApp = self.apps.${packageName};

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