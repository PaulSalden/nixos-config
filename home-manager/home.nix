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
    bibata-cursors
    freerdp
    keepassxc
    nerd-fonts.jetbrains-mono
    pwvucontrol
    steam-run
    swaybg
    swayidle
    wlsunset
  ];

  xdg.desktopEntries."com.freerdp.client.sdl3" = {
    name = "psaldenws1";
    exec = "sdl-freerdp +clipboard +fonts /dynamic-resolution /network:broadband-low /u:pauls /d:comsol /v:psaldenws1 -grab-keyboard /prevent-session-lock";
    icon = "krdc";
    terminal = false;
    type = "Application";
    #categories = [ "Utility" ];
  };

  home.file."sync".source =
    config.lib.file.mkOutOfStoreSymlink "/var/sync";
  home.file."Pictures".source =
    config.lib.file.mkOutOfStoreSymlink "/var/sync/Pictures";

  #age = {
  #  identityPaths = [ "/home/paul/.ssh/id_rsa" ];
  #  secrets = {
  #    example-secret = {
  #      file = ../secrets/wgprivate-secret.age;
  #    };
  #  };
  #};

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

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "26.05";
}
