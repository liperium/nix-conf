{ config
, pkgs
, lib
, ...
}:
let
  #protonup-rs = pkgs.callPackage ./protonup-rs/default.nix { };
in
{
  # Tools
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  users.users.liperium = {
    packages = with pkgs; [
      # Tools
      mangohud
      goverlay
      # Wine
      wineWow64Packages.waylandFull
      winetricks

      # Launchers
      #lutris
      faugus-launcher
      (heroic.override {
        extraPkgs = pkgs: [
          pkgs.gamemode
        ];
      })

      # Games
      prismlauncher
      temurin-bin-8
      temurin-bin-17
      #starsector
    ];
  };
  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs =
        pkgs: with pkgs; [
          libxcursor
          libxi
          libxinerama
          libxscrnsaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils
        ];
    };
  };
  # Save backups land in the Nextcloud-synced folder; restore with `ludusavi restore` on the other PC.
  # Config is a read-only store symlink, so GUI setting changes won't persist.
  home-manager.users.liperium.services.ludusavi = {
    enable = true;
    settings = {
      manifest.url = "https://raw.githubusercontent.com/mtkennerly/ludusavi-manifest/master/data/manifest.yaml";
      roots = [
        { path = "~/.local/share/Steam"; store = "steam"; }
        { path = "~/.config/heroic"; store = "heroic"; }
      ];
      backup.path = "~/Documents/Nextcloud/Games/ludusavi";
      # Skip games Steam Cloud already syncs
      backup.filter.cloud = { exclude = true; steam = true; };
      restore.path = "~/Documents/Nextcloud/Games/ludusavi";
      customGames = [
        { name = "Starsector"; files = [ "~/.local/share/starsector/saves" "~/.local/share/starsector/mods" ]; }
        # Settings/keybinds/addon SavedVariables only; addons themselves come from WowUp
        { name = "World of Warcraft"; files = [ "~/Games/battlenet/drive_c/Program Files (x86)/World of Warcraft/_retail_/WTF" ]; }
      ];
    };
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    gamescopeSession.enable = true;
  };
}
