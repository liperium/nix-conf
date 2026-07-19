{ config
, pkgs
, lib
, inputs
, ...
}:

{
  services.xserver.xkb = {
    layout = "us";
    variant = "alt-intl";
  };
  nixpkgs.config.permittedInsecurePackages = [ "electron-27.3.11" "electron-39.8.10" ];
  boot.kernelPackages = pkgs.linuxPackages_zen;

  users.users.liperium = {
    packages = with pkgs; [
      stable.logseq
    ];
  };
  #Fonts
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
      };
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # AppImage support
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
