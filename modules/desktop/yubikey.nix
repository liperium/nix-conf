{ config
, pkgs
, lib
, dconf
, ...
}:

{
  services.udev.packages = [ pkgs.yubikey-personalization ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
