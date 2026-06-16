{ pkgs, lib, ... }:

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

  xdg.configFile."kdeglobals".text = ''
    [General]
    TerminalApplication=foot
    TerminalService=foot.desktop

    [Icons]
    Theme=Papirus-Dark
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
