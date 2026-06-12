# Drop-in snippet for a host configuration (e.g. shuttle-n150).
# Adjust secretsFile if your module path differs.

{
  imports = [ ../../modules/services/ml-ninja ];

  services.ml-ninja = {
    enable = true;
    port = 8012;
    secretsFile = ../../../modules/secrets/ml-ninja.env;
    # imageTag = "latest";
  };
}
