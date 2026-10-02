{ config, ... }:
{
  age.secrets.wg-key = {
    file = "/home/paul/nixos-conf/secrets/wgprivate-secret.age";
  };

  networking.firewall.allowedUDPPorts = [ 36421 ];

  networking.wireguard = {
    enable = true;
    interfaces = {
      # network interface name.
      # You can name the interface arbitrarily.
      wg0 = {
        # the IP address and subnet of this peer
        ips = [ "10.13.37.4/24" ];

        # WireGuard Port
        # Must be accessible by peers
        listenPort = 36421;

        # Path to the private key file.
        #
        # Note: can also be included inline via the privateKey option,
        # but this makes the private key world-readable;
        # using privateKeyFile is recommended.
        privateKeyFile = config.age.secrets.wg-key.path;

        peers = [
          { 
            name = "pi";
            publicKey = "SwZh12ZVoBTx7i/PJxWP3lkJWO8NfaE8oBBvzizb1zs=";
            allowedIPs = [ "10.13.37.0/24" ];
            endpoint = "192.168.2.201:36421";
            #  ToDo: route to endpoint not automatically configured
            # https://wiki.archlinux.org/index.php/WireGuard#Loop_routing
            # https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577
            # Send keepalives every 25 seconds. Important to keep NAT tables alive.
            # persistentKeepalive = 25;
          }
          {
            name = "phone";
            publicKey = "084q9c5QUC3Vn1N3mHH5ThBvGbNwdg5AK09QW3F93UQ=";
            allowedIPs = [ "10.13.37.2/32" ];
          }
          {
            name = "laptop";
            publicKey = "5GwHK6tE7ZyKySp6U7YWOFxYA547ofv47RTOsnzO0Bs=";
            allowedIPs = [ "10.13.37.3/32" ];
          }
          #{
          #  name = "pi";
          #  publicKey = "SwZh12ZVoBTx7i/PJxWP3lkJWO8NfaE8oBBvzizb1zs=";
          #  allowedIPs = [ "10.13.37.0/24" ];
          #}
        ];
      };
    };
  };
}
# it’s not imperative but it does not know how to do it :
# sudo ip route add 11.111.11.111 via 192.168.1.11 dev wlo1
# the ip adresse 11: external and 192: local.
