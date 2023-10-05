{
  description = "Flake packaging of protonup-rs";

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.protonup-rs = stdenv.mkDerivation rec {
      pname = "protonup-rs";
      version = "0.6.0";

      src = fetchurl {
        url = "https://github.com/auyer/Protonup-rs/releases/download/${version}/protonup-rs-linux-amd64.zip";
        
        sha256 = "d03f873a952f0db67bfadf31da771a378aab7d3902219be3d0794d2d0de0bf98";
      };

      installPhase = ''
        install -D $src $out/bin/protonup-rs
      '';

      meta = {
        description = "Lib, CLI and GUI(wip) program to automate the installation and update of Proton-GE";
        platforms = nixpkgs.lib.platforms.linux;
      };
    };
  };
}