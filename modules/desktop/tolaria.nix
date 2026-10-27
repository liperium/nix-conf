{ lib, appimageTools, fetchurl, nodejs }:

let
  pname = "tolaria";
  version = "2026.10.13";
  src = fetchurl {
    url = "https://github.com/refactoringhq/tolaria/releases/download/v2026-10-13/Tolaria_${version}_amd64.AppImage";
    hash = "sha256-yOtnLOl4qcpHVN5ezYnYT5leBHOV+FfKjGYutTtTong=";
  };
  contents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  # Override Tolaria's AppImage fallback that disables accelerated compositing.
  profile = ''
    export WEBKIT_DISABLE_COMPOSITING_MODE=0
    export WEBKIT_DISABLE_DMABUF_RENDERER=0
    export PATH="${lib.makeBinPath [ nodejs ]}:$PATH"
  '';

  extraPkgs = pkgs: [
    pkgs.webkitgtk_4_1
    pkgs.libepoxy
    pkgs.nghttp2.lib
  ];

  extraInstallCommands = ''
    install -Dm644 ${contents}/Tolaria.desktop $out/share/applications/tolaria.desktop
    cp -r ${contents}/usr/share/icons $out/share/
  '';

  meta = {
    description = "Desktop app to manage markdown knowledge bases";
    homepage = "https://github.com/refactoringhq/tolaria";
    license = lib.licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
    mainProgram = "tolaria";
  };
}
