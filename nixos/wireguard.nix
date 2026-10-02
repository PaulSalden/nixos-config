{ config, ... }:
{
  age.secrets.wg-key = {
    file = "/home/paul/nixos-conf/secrets/wgprivate-secret.age";
  };

  networking.firewall.allowedUDPPorts = [ 36421 ];

  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "10.13.37.4/24" ];
      listenPort = 36421;
      privateKeyFile = config.age.secrets.wg-key.path;

      peers = [
        {
          publicKey = "SwZh12ZVoBTx7i/PJxWP3lkJWO8NfaE8oBBvzizb1zs=";
          allowedIPs = [ "10.13.37.0/24" ];
          endpoint = "192.168.2.201:36421";
        }
        {
          publicKey = "084q9c5QUC3Vn1N3mHH5ThBvGbNwdg5AK09QW3F93UQ=";
          allowedIPs = [ "10.13.37.2/32" ];
        }
        {
          publicKey = "5GwHK6tE7ZyKySp6U7YWOFxYA547ofv47RTOsnzO0Bs=";
          allowedIPs = [ "10.13.37.3/32" ];
        }
      ];
    };
  };
}
