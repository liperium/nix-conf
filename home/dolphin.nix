{ pkgs, lib, ... }:

let
  # Catppuccin Mocha palette, KDE wants "r,g,b"
  text = "205,214,244";
  subtext1 = "186,194,222";
  subtext0 = "166,173,200";
  overlay2 = "147,153,178";
  overlay1 = "127,132,156";
  overlay0 = "108,112,134";
  surface2 = "88,91,112";
  surface1 = "69,71,90";
  surface0 = "49,50,68";
  base = "30,30,46";
  mantle = "24,24,37";
  crust = "17,17,27";

  mauve = "203,166,247";
  red = "243,139,168";
  yellow = "249,226,175";
  green = "166,227,161";
  blue = "137,180,250";
  lavender = "180,190,254";

  accent = mauve;

  # Same foreground set for every color group
  foregrounds = bg: ''
    BackgroundNormal=${bg.normal}
    BackgroundAlternate=${bg.alternate}
    DecorationFocus=${accent}
    DecorationHover=${accent}
    ForegroundActive=${accent}
    ForegroundInactive=${subtext0}
    ForegroundLink=${blue}
    ForegroundNegative=${red}
    ForegroundNeutral=${yellow}
    ForegroundNormal=${text}
    ForegroundPositive=${green}
    ForegroundVisited=${lavender}
  '';
in
{
  xdg.configFile."dolphinrc".text = ''
    MenuBar=Disabled

    [ContextMenu]
    ShowOpenTerminal=false

    [General]
    GlobalViewProps=false
    Version=202

    [MainWindow]
    MenuBar=Disabled

    [PreviewSettings]
    Plugins=audiothumbnail,blenderthumbnail,exrthumbnail,ffmpegthumbs,fontthumbnail,imagethumbnail,jpegthumbnail,kraorathumbnail,svgthumbnail,windowsimagethumbnail,windowsexethumbnail
  '';

  home.file.".local/share/kio/servicemenus/openYaziHere.desktop".text = ''
    [Desktop Entry]
    Type=Service
    ServiceTypes=KonqPopupMenu/Plugin
    MimeType=inode/directory;
    Actions=openYaziHere;
    X-KDE-Priority=TopLevel

    [Desktop Action openYaziHere]
    TryExec=yazi
    Exec=foot --working-directory %f -e yazi
    Name=Open Yazi Here
    Icon=utilities-file-manager
    Comment=Opens yazi at the current folder
  '';

  home.file.".local/share/kio/servicemenus/openVSCodeHere.desktop".text = ''
    [Desktop Entry]
    Type=Service
    ServiceTypes=KonqPopupMenu/Plugin
    MimeType=inode/directory;
    Actions=openVSCodeHere;
    X-KDE-Priority=TopLevel

    [Desktop Action openVSCodeHere]
    TryExec=code
    Exec=code %f
    Name=Open VS Code Here
    Icon=vscode
    Comment=Opens VS Code at the current folder
  '';

  home.file.".local/share/kio/servicemenus/openFootHere.desktop".text = ''
    [Desktop Entry]
    Type=Service
    ServiceTypes=KonqPopupMenu/Plugin
    MimeType=inode/directory;
    Actions=openFootHere;
    X-KDE-Priority=TopLevel

    [Desktop Action openFootHere]
    TryExec=foot
    Exec=foot --working-directory %f
    Name=Open Foot Here
    Icon=utilities-terminal
    Comment=Opens a terminal at the current folder
  '';

  xdg.mimeApps.defaultApplications =
    lib.genAttrs [
      "text/plain"
      "text/markdown"
      "text/csv"
      "text/x-log"
      "text/x-nix"
      "text/x-python"
      "text/x-shellscript"
      "application/x-shellscript"
      "application/json"
      "application/toml"
      "application/x-yaml"
      "application/xml"
      "text/xml"
    ] (_: "Helix.desktop")
    // lib.genAttrs [
      "image/png"
      "image/jpeg"
      "image/gif"
      "image/webp"
      "image/avif"
      "image/svg+xml"
      "image/tiff"
      "image/bmp"
    ] (_: "org.kde.gwenview.desktop");

  # KDE apps (dolphin, gwenview, ...) take their palette from kdeglobals via
  # KColorScheme, not from qt6ct. Without [Colors:*] here they fall back to the
  # Breeze *light* defaults while Kvantum paints the widgets dark -> unreadable mix.
  xdg.configFile."kdeglobals".text = ''
    [General]
    TerminalApplication=foot
    TerminalService=foot.desktop
    ColorScheme=Catppuccin-Mocha-Mauve
    Name=Catppuccin Mocha Mauve
    shadeSortColumn=true

    [Icons]
    Theme=Papirus-Dark

    [KDE]
    contrast=4
    widgetStyle=kvantum

    [Colors:Window]
    ${foregrounds { normal = base; alternate = mantle; }}

    [Colors:View]
    ${foregrounds { normal = mantle; alternate = base; }}

    [Colors:Button]
    ${foregrounds { normal = surface0; alternate = surface1; }}

    [Colors:Tooltip]
    ${foregrounds { normal = mantle; alternate = base; }}

    [Colors:Complementary]
    ${foregrounds { normal = crust; alternate = mantle; }}

    [Colors:Header]
    ${foregrounds { normal = mantle; alternate = crust; }}

    [Colors:Header][Inactive]
    ${foregrounds { normal = crust; alternate = mantle; }}

    [Colors:Selection]
    BackgroundNormal=${accent}
    BackgroundAlternate=${accent}
    DecorationFocus=${accent}
    DecorationHover=${accent}
    ForegroundActive=${base}
    ForegroundInactive=${base}
    ForegroundLink=${base}
    ForegroundNegative=${red}
    ForegroundNeutral=${yellow}
    ForegroundNormal=${base}
    ForegroundPositive=${green}
    ForegroundVisited=${base}

    [WM]
    activeBackground=${mantle}
    activeBlend=${text}
    activeForeground=${text}
    inactiveBackground=${crust}
    inactiveBlend=${subtext1}
    inactiveForeground=${overlay1}

    [ColorEffects:Disabled]
    Color=${surface0}
    ColorAmount=0
    ColorEffect=0
    ContrastAmount=0.65
    ContrastEffect=1
    IntensityAmount=0.1
    IntensityEffect=2

    [ColorEffects:Inactive]
    ChangeSelectionColor=true
    Color=${surface1}
    ColorAmount=0.025
    ColorEffect=2
    ContrastAmount=0.1
    ContrastEffect=2
    Enable=false
    IntensityAmount=0
    IntensityEffect=0
  '';

  home.activation.qtctIconTheme = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    for f in "$HOME/.config/qt5ct/qt5ct.conf" "$HOME/.config/qt6ct/qt6ct.conf"; do
      [ -e "$f" ] || continue
      if [ -L "$f" ]; then
        target=$(readlink -f "$f")
        rm "$f"
        install -m 644 "$target" "$f"
      fi
      if ! grep -q "^icon_theme=" "$f"; then
        sed -i '/^\[Appearance\]/a icon_theme=Papirus-Dark' "$f"
      fi
    done
  '';

  home.packages = with pkgs; [
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    kdePackages.qt6ct
    (catppuccin-kvantum.override {
      accent = "mauve";
      variant = "mocha";
    })
  ];
}
