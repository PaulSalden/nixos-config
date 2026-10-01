{ pkgs, config, ... }:

{
  age.secrets.kpnpw.file = ../secrets/kpn-secret.age;

  accounts.email.accounts.personal = {
    primary = true;
    address = "paul@salden.me";
    realName = "Paul Salden";
    userName = "paulsalden@kpnmail.nl";
    passwordCommand = "sh -c 'cat ${config.age.secrets.kpnpw.path}'";

    imap = {
      host = "imap.kpnmail.nl";
      port = 993;
      tls.enable = true;
    };

    smtp = {
      host = "smtp.kpnmail.nl";
      port = 587;
      tls.enable = true;
    };

    # Generates aerc account settings automatically
    aerc.enable = true;
  };

  programs.aerc.enable = true;
  programs.aerc.extraConfig.general.unsafe-accounts-conf = true; # required with HM
}
