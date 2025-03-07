{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    firefox
  ];

  xdg.desktopEntries = {
    firefox-fusion = {
      name = "Firefox - fusion";
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

    firefox-cegepj = {
      name = "Firefox - Cegep";
      genericName = "Web Browser Cegep";
      exec = "firefox %U -p cegepj";
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

