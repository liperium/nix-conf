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

  # Quiet graphical boot; hosts set boot.loader.timeout.
  boot = {
    plymouth = {
      enable = true;
      theme = "bgrt";
    };
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
  };

  # Compressed RAM swap; used before any disk swap thanks to higher priority.
  # memoryPercent is a cap, not a reservation: RAM is only taken as pages get swapped.
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };
  boot.kernel.sysctl = {
    # 100 = anon and file pages cost the same to reclaim. Less eager than the usual
    # zram 180 so a running game's working set isn't compressed while it's still hot.
    "vm.swappiness" = lib.mkDefault 100;
    # zram has no seek cost, so don't read ahead neighbouring pages.
    "vm.page-cluster" = 0;
  };

  users.users.liperium = {
    packages = with pkgs; [
      logseq
    ];
  };
  environment.systemPackages = [
    (pkgs.callPackage ./tolaria.nix { })
  ];
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

  services.flatpak.enable = true; # Slack

  # AppImage support
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
}
