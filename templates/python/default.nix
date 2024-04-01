# This creates a venv to use with your IDE of choice.
let
  pkgs = import <nixpkgs> { };
  azuremlpkgs = import ./.;
  python = pkgs.python310;
  pythonPackages = python.pkgs;
in

with pkgs;

mkShell {
  name = "pip-env";
  buildInputs = with pythonPackages; [
    # Python requirements (enough to get a virtualenv going).
    numpy
    opencv4
    matplotlib
    scikit-learn
    scikit-image
    pandas

    venvShellHook
  ];
  venvDir = "venv310";
  src = null;
  postVenv = ''
    unset SOURCE_DATE_EPOCH
    ./scripts/install_local_packages.sh
  '';
  postShellHook = ''
    # Allow the use of wheels.
    unset SOURCE_DATE_EPOCH
    PYTHONPATH=$PWD/$venvDir/${python.sitePackages}:$PYTHONPATH
  '';
}
