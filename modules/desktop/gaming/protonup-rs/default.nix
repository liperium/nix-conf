{ lib
, rustPlatform
, fetchFromGitHub
,
}:

rustPlatform.buildRustPackage rec {
  pname = "protonup-rs";
  version = "0.8.6";
  mainProgram = "protonup-rs";

  src = fetchFromGitHub {
    owner = "auyer";
    repo = "Protonup-rs";
    rev = "v${version}";
    hash = "sha256-nBSrY4DAHRphzJ3VfausBAJcLKNxSVR0VNSzWreCs8E=";
  };

  cargoHash = "sha256-4aCe1ZIfYCQbBbjpf8200rTLB+Af1YnWvfspIHMIm9Y=";

  # Can't seem to pass these tests? Network access?
  # github::tests::test_get_release, github::tests::test_list_releases
  checkFlags = [ "--skip={github::tests::test_get_release, github::tests::test_list_releases}" ];

  meta = with lib; {
    description = "Lib, CLI and GUI(wip) program to automate the installation and update of Proton-GE";
    homepage = "https://github.com/auyer/Protonup-rs/";
    license = licenses.asl20;
    maintainers = with maintainers; [ liperium ];
    platforms = [ "x86_64-linux" ];
  };
}
