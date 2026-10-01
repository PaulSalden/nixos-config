{ pkgs, config, ... }:

{
  age.secrets.radpw.file = ../secrets/radicale-secret.age;

  # 1. Define Calendar Accounts
  accounts.calendar = {
    basePath = "${config.home.homeDirectory}/.local/share/calendars";
    
    accounts.personal = {
      primary = true;
      primaryCollection = "personal";

      # CalDAV Remote Server Details
      remote = {
        type = "caldav";
        url = "http://10.13.37.201:7229/paul/8e3a4196-cfa6-8b19-ccfe-998e7fd72495/";
        userName = "paul";
        passwordCommand = [ "sh" "-c" "cat ${config.age.secrets.radpw.path}" ];
      };

      # Enable vdirsyncer to fetch this calendar locally
      vdirsyncer = {
        enable = true;
        #collections = [ "bla" ]; # Syncs all collections or specify specific ones
      };

      # Enable khal to display this local calendar
      khal = {
        enable = true;
        #type = "discover";
        color = "dark blue";
      };
    };
  };

  # 2. Configure khal (TUI Calendar)
  programs.khal = {
    enable = true;
    settings = {
      default = {
        default_calendar = "personal";
        timedelta = "5d";
      };
      #view = {
      #  agenda_day_format = "%A, %d %B %Y";
      #};
    };
  };

  # 3. Configure vdirsyncer & Background Sync Service
  programs.vdirsyncer.enable = true;

  services.vdirsyncer = {
    enable = true;
    frequency = "*:0/15"; # Automatically sync every 15 minutes via systemd user timer
  };
}
