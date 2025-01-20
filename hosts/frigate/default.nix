{ lib
, config
, pkgs
, ...
}:
let
  regreet-theme =
    (pkgs.catppuccin-gtk.override {
      variant = "mocha";
      accents = [ "mauve" ];
    });
in
{

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules.nix
  ];
  networking.hostName = "frigate";
  networking.firewall.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-2a9c4cee-d3a3-41ce-9d46-f48a7cf2d703".device = "/dev/disk/by-uuid/2a9c4cee-d3a3-41ce-9d46-f48a7cf2d703";
 
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

  services.openssh = {
    enable = true;
    ports = [ 22 ];
  };
  services.upower.enable = true;
  environment.systemPackages = with pkgs;
    [
      # Hyprpanel
      upower
      bluez
      bluez-tools
      dart-sass
      brightnessctl
      regreet-theme
      # powertop
    ];

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;
  services.blueman.enable = true;

}
