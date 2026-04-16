{ config, pkgs, hyprMonitor, ... }:

{
  imports = [
    ./hyprland-conf.nix
    #./rofi
    ./quickshell
    ./hypridle
  ];
  #xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;
  xdg.configFile."hypr/macchiato.conf".source = ./macchiato.conf;
  #xdg.configFile."hypr/scripts/waybar/start.sh".source = ./scripts/waybar/start.sh;

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

  # Set foot as the terminal for KDE apps (Dolphin "Open in Terminal")
  xdg.configFile."kdeglobals".text = ''
    [General]
    TerminalApplication=foot
    TerminalService=foot.desktop
  '';

  home.packages = with pkgs; [
    # For audio keyboard shortcuts (pactl is included in pulseaudio)
    #playerctl # For play/pause/next/previous
    brightnessctl
    # Theming
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    kdePackages.qt6ct
    (catppuccin-kvantum.override {
      accent = "mauve";
      variant = "mocha";
    })

    # Others
    hyprland-qtutils
    hyprshot
  ];

  wayland.windowManager.hyprland = {
    # Whether to enable Hyprland wayland compositor
    enable = true;
    # The hyprland package to use
    # Disable them because managed by NixOs
    package = null;
    #portalPackage = null;
    systemd.enable = false;
    # Whether to enable XWayland
    xwayland.enable = true;

  };
}
