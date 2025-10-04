{ pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./services.nix
    ./modules.nix
  ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  environment.systemPackages = with pkgs; [
    dig # nameserver stuff
  ];
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
  };
  networking = {
    hostName = "rpi4";
    networkmanager.enable = true;
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
      "8.8.4.4"
    ];
    wireguard.enable = true;
  };

  users = {
    users."liperium" = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCuy8aQB6/3boeLYRGjKqw90mJTgpxs+ltZERfN4yCwNKeY8fifBzBiHt1m+KNko1BfTAFKzdwKCvxg55xUopzxFO/d0btNIvWMMCq6rtW9viY1S3kq3zCAbbFkwdnxRB2cRmEuRyLkhz1fkJGllGu4zrnAsXg2UUZ69o2Ljne3I8gTBHNpaCdjLu+1tpVmHXDgCuJwlLHZf7faKwQtk65GYGutWFWZy0v/LQK18Cyw3paWmn5W0o8+dt243eeZmnMxHLGW8ctOiUr0ZwGcTEzDh5Tt4yIbjwYP32XU0Cc2bJm2nbvlOH9smvL1measv+27He0vynsMwt/0W6pUcxNDe23lDzDaDmexilSUmatrX/HlnHeHPlM4sAS68xlVu3JQX7cbxTG1HjkAsX1bZZtYYgMVHXIvu0I+IOWXhX0PdSqwTKddF/yCJlVVopAzzv0/Zl0stqyKOtp+9GE2hirMAJGd0WDNfHCZeicNhTNyBx0kDQZCq9cdHZN2UDE7/Kk= liperium@battleship"
      ];
    };
  };

  system.stateVersion = "24.11";
}
