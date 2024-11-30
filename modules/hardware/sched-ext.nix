{ config
, pkgs
, lib
, ...
}: {
  boot.kernelPackages = pkgs.linuxPackages_cachyos;
  environment.systemPackages = [ pkgs.scx.lavd ];
  chaotic.scx = {
    enable = true;
    package = pkgs.scx.lavd;
    scheduler = "scx_lavd";
  };
}
