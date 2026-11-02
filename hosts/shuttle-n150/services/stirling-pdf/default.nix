{ ... }:
{
  services.stirling-pdf = {
    enable = true;
    environment = { SERVER_PORT = 6666; };
  };
}
