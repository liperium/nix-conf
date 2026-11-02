{ pkgs, lib, ... }:
{
  services.prowlarr.enable = true; # 9696
  services.sonarr.enable = true; # 8989
  services.sonarr.group = "users";
  services.radarr.enable = true; # 7878
  services.radarr.group = "users";
  services.flaresolverr.enable = true; # 8191
  services.seerr.enable = true; # 5055 (was services.jellyseerr; state stays in /var/lib/jellyseerr)
  services.bazarr.enable = true; # 6767
  services.bazarr.group = "users";

  # Ensure files/dirs created by *arr services are group-writable so
  # bazarr (same `users` group) can write subtitles next to videos.
  systemd.services.radarr.serviceConfig.UMask = lib.mkForce "0002";
  systemd.services.sonarr.serviceConfig.UMask = lib.mkForce "0002";
  systemd.services.bazarr.serviceConfig.UMask = lib.mkForce "0002";
  systemd.services.bazarr.path = [ pkgs.mediainfo ];
}
