{ config, pkgs, ... }:
let
  regreet-theme =
    (pkgs.catppuccin-gtk.override {
      variant = "mocha";
      accents = [ "mauve" ];
    });
in
{
  imports = [
    ./hardware-configuration.nix
    ./modules.nix
  ];
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "battleship";

  environment.systemPackages = with pkgs; [
    nvtopPackages.amd
    os-prober # Probes for windows for grub
    greetd.regreet
    (catppuccin-grub.override {
      flavor = "mocha";
    })
    gparted
    rkdeveloptool
  ];

  #Bambu-studio
  services.flatpak.enable = true;

  boot = {
    plymouth = {
      enable = true;
      theme = "bgrt";
    };
    # Enable "Silent Boot"
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

    loader = {
      timeout = 3;
      grub.theme = "${pkgs.catppuccin-grub}";
    };
  };

  # Greetd start
  environment.etc = {
    greetd-regreet-hyprland = {
      text = ''
        exec-once = ${pkgs.greetd.regreet}/bin/regreet --style ${regreet-theme}/share/themes/catppuccin-mocha-mauve-standard/gtk-4.0/gtk-dark.css; hyprctl dispatch exit
        misc {
            disable_hyprland_logo = true
            disable_splash_rendering = true
            disable_hyprland_qtutils_check = true
        }
      '';
      mode = "0444";
    };
  };
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.unstable.hyprland}/bin/Hyprland --config /etc/greetd-regreet-hyprland";
        user = "greeter";
      };
    };
  };
  programs.regreet.enable = true;
  # Greetd end

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };
  # Power management
  services.power-profiles-daemon.enable = true;

  #Dual boot, systemd can't see other EFI partition, use grub instead
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub.enable = true;
    grub.devices = [ "nodev" ];
    grub.efiSupport = true;
    grub.useOSProber = true;
  };
}
