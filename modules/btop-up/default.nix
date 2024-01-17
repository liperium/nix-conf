{ lib
, stdenv
, fetchFromGitHub
, darwin
, removeReferencesTo
, btop
, testers
}:
let pkgs = import <nixpkgs> {};
in
stdenv.mkDerivation rec {
  pname = "btop";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "aristocratos";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-QQM2/LO/EHovhj+S+4x3ro/aOVrtuxteVVvYAd6feTk=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.CoreFoundation
    darwin.apple_sdk_11_0.frameworks.IOKit
    #pkgs.rocmPackages.rocm-smi
  ];

  makeFlags = [ "GPU_SUPPORT=true" ];

  env.ADDFLAGS = lib.optionalString stdenv.isDarwin
    "-F${darwin.apple_sdk_11_0.frameworks.IOKit}/Library/Frameworks/";

  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    ${removeReferencesTo}/bin/remove-references-to -t ${stdenv.cc.cc} $(readlink -f $out/bin/btop)
  '';

  passthru.tests.version = testers.testVersion {
    package = btop;
  };

  meta = with lib; {
    description = "A monitor of resources";
    homepage = "https://github.com/aristocratos/btop";
    changelog = "https://github.com/aristocratos/btop/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ rmcgibbo ];
    mainProgram = "btop";
  };
}