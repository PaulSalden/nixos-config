# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./calendar.nix
    ./contacts.nix
    ./mail.nix
    ./waybar.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  home = {
    username = "paul";
    homeDirectory = "/home/paul";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  programs.chromium.enable = true;

  programs.tmux = {
    enable = true;
    mouse = true;
    terminal = "screen-256color";
  };

  programs.yazi.enable = true;
  programs.yazi.enableBashIntegration = true;
  programs.yazi.settings = {
    opener.image = [
      {
        run = ''swayimg "$@"'';
        orphan = true;
        desc = "View Image";
      }
    ];
    open.rules = [ { mime = "image/*"; use = "image"; } ];
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Paul Salden";
        email = "paul.salden@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };

  home.packages = with pkgs; [
    app2unit
    beyond-all-reason
    bibata-cursors
    freerdp
    keepassxc
    mpv
    pwvucontrol
    signal-desktop
    steam-run
    swaybg
    swayidle
    swayimg
    syncthing
    syncthingtray
    teamspeak6-client
    wlsunset
  ];

  xdg.desktopEntries."com.freerdp.client.sdl3" = {
    name = "psaldenws1";
    exec = "sdl-freerdp +clipboard +fonts /dynamic-resolution /network:broadband-low /u:pauls /d:comsol /v:psaldenws1 -grab-keyboard /prevent-session-lock";
    icon = "computer";
    terminal = false;
    type = "Application";
    #categories = [ "Utility" ];
  };

  home.file."sync".source =
    config.lib.file.mkOutOfStoreSymlink "/var/sync";
  home.file."Pictures".source =
    config.lib.file.mkOutOfStoreSymlink "/var/sync/Pictures";
  home.file.".local/state/syncthing".source =
    config.lib.file.mkOutOfStoreSymlink "/var/sync/Config/syncthing-desktop";

  age.identityPaths = [ "${config.home.homeDirectory}/.config/agenix/key.txt" ];

  # GTK Configuration
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita"; # Or "Adwaita-dark"
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    font = {
      name = "Inter";
      size = 10;
    };
  };

  # Qt Configuration
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style = {
      name = "adwaita"; # Or "adwaita-dark"
      package = pkgs.adwaita-qt;
    };
  };

  fonts.fontconfig.defaultFonts = {
    monospace = [ "JetBrainsMono Nerd Font" ];
    sansSerif = [ "Inter" ];
  };


  programs.bash.enable = true;
  programs.bash.shellAliases = {
    avpn = "ssh -o RemoteCommand=/home/paul/connectvpn.sh virt";
  };

  # Required for media keys
  services.playerctld.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "26.05";
}
