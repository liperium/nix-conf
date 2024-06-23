{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    firefox
  ];

  xdg.desktopEntries = {
    firefox-fusion = {
      name = "Firefox - FJ";
      genericName = "Web Browser Fusion";
      exec = "firefox %U -p fusion";
      icon = "firefox";
      terminal = false;
      categories = [
        "Application"
        "Network"
        "WebBrowser"
      ];
      mimeType = [
        "text/html"
        "text/xml"
      ];
    };
  };
}

