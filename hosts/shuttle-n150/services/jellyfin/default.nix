{ pkgs, ... }:
{
  services.jellyfin.enable = true; # 8096
  systemd.services.jellyfin.environment.LIBVA_DRIVER_NAME = "iHD";
  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];
  # from https://wiki.nixos.org/wiki/Jellyfin
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-ocl # generic OpenCL support, for all processors
      # For newer processors (Broadwell and higher, ca. 2014), use this paired with `LIBVA_DRIVER_NAME=iHD`:
      intel-media-driver
      intel-compute-runtime
      vpl-gpu-rt
    ];
  };
}
