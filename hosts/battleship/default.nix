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
  networking.hostName = "battleship";

  environment.systemPackages = with pkgs; [
    nvtopPackages.amd
    os-prober # Probes for windows for grub
    greetd.regreet
  ];

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
        command = "${pkgs.hyprland}/bin/Hyprland --config /etc/greetd-regreet-hyprland";
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

  #Dual boot, systemd can't see other EFI partition, use grub instead
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub.enable = true;
    grub.devices = [ "nodev" ];
    grub.efiSupport = true;
    grub.useOSProber = true;
  };
}
