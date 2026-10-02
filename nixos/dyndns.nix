{ pkgs, config, ... }:

{
  age.secrets.cloudflare-api-token.file = ../secrets/cloudflare-secret.age;

  services.cloudflare-dyndns = {
    enable = true;
    apiTokenFile = config.age.secrets.cloudflare-api-token.path;
    domains = [ "xeqavqba.salden.me" ];
    ipv4 = false;
    ipv6 = true;
  };
}
