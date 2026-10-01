{ pkgs, config, ... }:

{
  age.secrets.radpw.file = ../secrets/radicale-secret.age;

  # 1. Enable khard and aerc
  programs.khard.enable = true;
  programs.aerc.enable = true;
  programs.vdirsyncer.enable = true;

  # 2. Define Contact Accounts
  accounts.contact = {
    basePath = "${config.home.homeDirectory}/.local/share/contacts";

    accounts = {
      # Account 1: First Collection / Address Book
      personal = {
        remote = {
          type = "carddav";
          url = "http://10.13.37.201:7229/paul/66cef525-e4cd-770c-43cc-5f8f9ef35327/";
          userName = "paul";
          passwordCommand = [ "sh" "-c" "cat ${config.age.secrets.radpw.path}" ];
        };

        vdirsyncer = {
          enable = true;
          #collections = null; # Treat URL directly as the collection
        };

        khard.enable = true;
      };

      # Account 2: Second Collection / Address Book
      other = {
        remote = {
          type = "carddav";
          url = "http://10.13.37.201:7229/paul/cde05958-b21c-289a-67da-95eed2cc863c/";
          userName = "paul";
          passwordCommand = [ "sh" "-c" "cat ${config.age.secrets.radpw.path}" ];
        };

        vdirsyncer = {
          enable = true;
          #collections = null;
        };

        khard.enable = true;
      };
    };
  };

  # 3. Connect Khard to Aerc for Address Completion
  programs.aerc.extraConfig = {
    compose = {
      # Pass input query directly to khard's completion command
      address-book-cmd = "${pkgs.khard}/bin/khard email --parsable %s";
    };
  };
}
