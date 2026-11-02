{ ... }:
{
  services.stash = {
    enable = true;
    username = "liperium";
    passwordFile = "/zfs-data/apps/stash/secrets/password";
    jwtSecretKeyFile = "/zfs-data/apps/stash/secrets/jwt-secret";
    sessionStoreKeyFile = "/zfs-data/apps/stash/secrets/session-key";
    settings.stash = [
      {
        path = "/zfs-data/apps/stash/videos";
        excludeimage = true;
      }
    ];
  };
}
