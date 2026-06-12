{
  imports = [ ../../../../modules/programs/invoice-ninja ];

  services.invoice-ninja = {
    enable = true;
    dataDir = "/zfs-data/apps/ml-invoice-ninja";
    secretsFile = ../../../../modules/secrets/invoice-ninja.env;
  };
}
