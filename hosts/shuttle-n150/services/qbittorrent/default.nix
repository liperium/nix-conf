{ pkgs, config, ... }:
{
  services.qbittorrent = {
    enable = true;
    user = "liperium";
    group = "1000";
    webuiPort = 8182;
    serverConfig = {
      Preferences = {
        WebUI = {
          Username = "admin";
          Password_PBKDF2 = "@ByteArray(gWgVRHk5xzEYpIdDVfuMJA==:j9e/dO7oA787eCwVvamJjouCeGVZUYC7DpCzaqFlTYT05TnzOzRVnHgbGiO/IxtgFIJaIl2BuWSl/TS3M72diQ==)";
        };
      };
    };
  };
}
