{ config, pkgs, ... }:

{
  age.secrets.wg-key = {
    file = "/home/paul/nixos-conf/secrets/wgprivate-secret.age";
    mode = "640";
    owner = "systemd-network";
    group = "systemd-network";
  };

  networking.firewall.allowedUDPPorts = [ 36421 ];

  systemd.network = {
    # 1. Define the WireGuard Virtual Network Device
    netdevs = {
      "50-wg0" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg0";
        };

        wireguardConfig = {
          PrivateKeyFile = config.age.secrets.wg-key.path;
          ListenPort = 36421;
          RouteTable = "main";
        };

        wireguardPeers = [
          {
            # Peer: pi
            PublicKey = "SwZh12ZVoBTx7i/PJxWP3lkJWO8NfaE8oBBvzizb1zs=";
            AllowedIPs = [ "10.13.37.0/24" ];
            Endpoint = "192.168.2.201:36421";
          }
          {
            # Peer: phone
            PublicKey = "084q9c5QUC3Vn1N3mHH5ThBvGbNwdg5AK09QW3F93UQ=";
            AllowedIPs = [ "10.13.37.2/32" ];
          }
          {
            # Peer: laptop
            PublicKey = "5GwHK6tE7ZyKySp6U7YWOFxYA547ofv47RTOsnzO0Bs=";
            AllowedIPs = [ "10.13.37.3/32" ];
          }
        ];
      };
    };

    # 2. Apply Network settings to wg0 (IP address and routes)
    networks = {
      "50-wg0" = {
        matchConfig.Name = "wg0";

        # Address assigned to this peer
        address = [ "10.13.37.4/24" ];

        # systemd-networkd automatically configures routes for the AllowedIPs 
        # defined under wireguardPeers above.
      };
    };
  };
}
