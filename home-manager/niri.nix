{ config, pkgs, ... }:

{
  # ---------------------------------------------------------------------------
  # Packages
  # Explicitly install all CLI tools, applications, and utilities mentioned.
  # ---------------------------------------------------------------------------
  home.packages = with pkgs; [
    # Wayland / Niri tools
    app2unit
    bibata-cursors
    fuzzel
    mako
    swaybg
    swayidle
    wlsunset
    xwayland-satellite
  ];

  # ---------------------------------------------------------------------------
  # Systemd User Services & Specialized Configurations
  # Replaces `spawn-at-startup` entries with native systemd management.
  # ---------------------------------------------------------------------------

  # 1. Night Light / Color Temperature (wlsunset)
  services.wlsunset = {
    enable = true;
    latitude = "51.041766829771085";
    longitude = "5.8570853075802";
  };

  # 2. Idle Management (swayidle)
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 600;
        command = "${pkgs.app2unit}/bin/app2unit --${pkgs.hyprlock}/bin/hyprlock";
      }
      {
        timeout = 601;
        command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
        resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
      }
    ];
    events = {
      before-sleep = "${pkgs.hyprlock}/bin/hyprlock";
    };
  };

  # 3. Wallpaper Service (swaybg)
  systemd.user.services.swaybg = {
    Unit = {
      Description = "Swaybg wallpaper daemon";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.swaybg}/bin/swaybg -i /home/paul/wallpaper";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # 4. Browser Autostart (Chromium)
  systemd.user.services.chromium-autostart = {
    Unit = {
      Description = "Chromium autostart";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.chromium}/bin/chromium";
      Restart = "no";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # 5. Native Cursor Management
  home.pointerCursor = {
    enable = true; # Fixed warning
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # ---------------------------------------------------------------------------
  # Niri Configuration
  # ---------------------------------------------------------------------------
  wayland.windowManager.niri.enable = true;
  wayland.windowManager.niri.settings = {
    input = {
      keyboard = {
        xkb.options = "compose:menu,caps:super";
        numlock = {};
      };
  
      touchpad = {
        tap = {};
        natural-scroll = {};
      };
  
      mouse = {
        accel-speed = -0.4;
        accel-profile = "flat";
      };
    };
  
    layout = {
      # gaps, background-color, focus-ring, border, shadow, tab-indicator and
      # insert-hint come from colors.kdl, which overrode config.kdl via `include`.
      gaps = 12;
  
      center-focused-column = "never";
      always-center-single-column = {};
  
      preset-column-widths._children = [
        { proportion = 0.33333; }
        { proportion = 0.5; }
        { proportion = 0.66667; }
        { proportion = 0.8; }
      ];
  
      default-column-width.proportion = 0.5;
  
      background-color = "#181716";
  
      focus-ring = {
        width = 2;
        active-gradient._props = {
          from = "#b39a8b";
          to = "#a5a38f";
          angle = 45;
          "in" = "oklab";
        };
        inactive-color = "#484441";
        urgent-gradient._props = {
          from = "#c97975";
          to = "#a85f5c";
          angle = 45;
        };
      };
  
      border = {
        off = {};
        width = 2;
        active-gradient._props = {
          from = "#b39a8b";
          to = "#a5a38f";
          angle = 45;
          "in" = "oklab";
        };
        inactive-color = "#48444180";
        urgent-gradient._props = {
          from = "#c97975";
          to = "#a85f5c";
          angle = 45;
        };
      };
  
      shadow = {
        on = {};
        softness = 18;
        spread = 2;
        offset._props = { x = 0; y = 4; };
        draw-behind-window = true;
        color = "#00000080";
        inactive-color = "#00000040";
      };
  
      tab-indicator = {
        width = 4;
        gap = 5;
        length._props.total-proportion = 1.0;
        position = "top";
        corner-radius = 6;
        active-gradient._props = {
          from = "#b39a8b";
          to = "#a5a38f";
          angle = 90;
        };
        inactive-color = "#403d3a";
        urgent-gradient._props = {
          from = "#c97975";
          to = "#a85f5c";
          angle = 90;
        };
      };
  
      insert-hint.gradient._props = {
        from = "#b39a8b30";
        to = "#a5a38f60";
        angle = 45;
      };
    };
  
    overview = {
      # 90% opacity overlay
      backdrop-color = "#181716e6";
      workspace-shadow.color = "#00000050";
    };
  
    recent-windows.highlight = {
      # Flat colors only; gradients are unsupported here.
      active-color = "#b39a8b80";
      urgent-color = "#c9797580";
    };
  
    prefer-no-csd = {};
  
    screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
  
    animations.slowdown = 0.5;
  
    environment = {
      SDL_VIDEO_DRIVER = "wayland";
      #QT_QPA_PLATFORMTHEME = "hyprqt6engine";
      XDG_MENU_PREFIX = "niri-";
    };
  
    hotkey-overlay.skip-at-startup = {};
  
    cursor = {
      xcursor-theme = "Bibata-Modern-Classic";
      xcursor-size = 24;
    };
  
    binds = {
      "Mod+Shift+Slash".show-hotkey-overlay = {};
  
      # Programs
      "Mod+T" = {
        _props.hotkey-overlay-title = "Open a Terminal: alacritty";
        spawn = ["alacritty"];
      };
      "Mod+D" = {
        _props.hotkey-overlay-title = "Run an Application: fuzzel";
        spawn = ["fuzzel" "--launch-prefix=app2unit --"];
      };
      "Super+Alt+L" = {
        _props.hotkey-overlay-title = "Lock the Screen: hyprlock";
        spawn-sh = "app2unit -- hyprlock & sleep 1 && niri msg action power-off-monitors";
      };
      "Mod+Y".spawn = ["app2unit" "--" "kitty" "yazi"];
      "Mod+X".spawn = ["app2unit" "--" "keepassxc"];
  
      # Media keys
      "XF86AudioRaiseVolume" = {
        _props.allow-when-locked = true;
        spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05+"];
      };
      "XF86AudioLowerVolume" = {
        _props.allow-when-locked = true;
        spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05-"];
      };
      "XF86AudioMute" = {
        _props.allow-when-locked = true;
        spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
      };
      "XF86AudioPlay" = {
        _props.allow-when-locked = true;
        spawn = ["playerctl" "play-pause"];
      };
      "XF86AudioPrev" = {
        _props.allow-when-locked = true;
        spawn = ["playerctl" "previous"];
      };
      "XF86AudioNext" = {
        _props.allow-when-locked = true;
        spawn = ["playerctl" "next"];
      };
  
      "Mod+O" = {
        _props.repeat = false;
        toggle-overview = {};
      };
  
      "Mod+Q".close-window = {};
  
      # Focus
      "Mod+Left".focus-column-left = {};
      "Mod+Down".focus-window-down = {};
      "Mod+Up".focus-window-up = {};
      "Mod+Right".focus-column-right = {};
      "Mod+H".focus-column-left = {};
      "Mod+J".focus-window-down = {};
      "Mod+K".focus-window-up = {};
      "Mod+L".focus-column-right = {};
  
      # Move columns/windows
      "Mod+Ctrl+Left".move-column-left = {};
      "Mod+Ctrl+Down".move-window-down = {};
      "Mod+Ctrl+Up".move-window-up = {};
      "Mod+Ctrl+Right".move-column-right = {};
      "Mod+Ctrl+H".move-column-left = {};
      "Mod+Ctrl+J".move-window-down = {};
      "Mod+Ctrl+K".move-window-up = {};
      "Mod+Ctrl+L".move-column-right = {};
  
      "Mod+Home".focus-column-first = {};
      "Mod+End".focus-column-last = {};
      "Mod+Ctrl+Home".move-column-to-first = {};
      "Mod+Ctrl+End".move-column-to-last = {};
  
      # Monitors
      "Mod+Shift+Left".focus-monitor-left = {};
      "Mod+Shift+Down".focus-monitor-down = {};
      "Mod+Shift+Up".focus-monitor-up = {};
      "Mod+Shift+Right".focus-monitor-right = {};
      "Mod+Shift+H".focus-monitor-left = {};
      "Mod+Shift+J".focus-monitor-down = {};
      "Mod+Shift+K".focus-monitor-up = {};
      "Mod+Shift+L".focus-monitor-right = {};
  
      "Mod+Shift+Ctrl+Left".move-column-to-monitor-left = {};
      "Mod+Shift+Ctrl+Down".move-column-to-monitor-down = {};
      "Mod+Shift+Ctrl+Up".move-column-to-monitor-up = {};
      "Mod+Shift+Ctrl+Right".move-column-to-monitor-right = {};
      "Mod+Shift+Ctrl+H".move-column-to-monitor-left = {};
      "Mod+Shift+Ctrl+J".move-column-to-monitor-down = {};
      "Mod+Shift+Ctrl+K".move-column-to-monitor-up = {};
      "Mod+Shift+Ctrl+L".move-column-to-monitor-right = {};
  
      # Workspaces
      "Mod+Page_Down".focus-workspace-down = {};
      "Mod+Page_Up".focus-workspace-up = {};
      "Mod+U".focus-workspace-down = {};
      "Mod+I".focus-workspace-up = {};
      "Mod+Ctrl+Page_Down".move-column-to-workspace-down = {};
      "Mod+Ctrl+Page_Up".move-column-to-workspace-up = {};
      "Mod+Ctrl+U".move-column-to-workspace-down = {};
      "Mod+Ctrl+I".move-column-to-workspace-up = {};
  
      "Mod+Shift+Page_Down".move-workspace-down = {};
      "Mod+Shift+Page_Up".move-workspace-up = {};
      "Mod+Shift+U".move-workspace-down = {};
      "Mod+Shift+I".move-workspace-up = {};
  
      # Mouse wheel
      "Mod+WheelScrollDown" = {
        _props.cooldown-ms = 150;
        focus-workspace-down = {};
      };
      "Mod+WheelScrollUp" = {
        _props.cooldown-ms = 150;
        focus-workspace-up = {};
      };
      "Mod+Ctrl+WheelScrollDown" = {
        _props.cooldown-ms = 150;
        move-column-to-workspace-down = {};
      };
      "Mod+Ctrl+WheelScrollUp" = {
        _props.cooldown-ms = 150;
        move-column-to-workspace-up = {};
      };
  
      "Mod+WheelScrollRight".focus-column-right = {};
      "Mod+WheelScrollLeft".focus-column-left = {};
      "Mod+Ctrl+WheelScrollRight".move-column-right = {};
      "Mod+Ctrl+WheelScrollLeft".move-column-left = {};
  
      "Mod+Shift+WheelScrollDown".focus-column-right = {};
      "Mod+Shift+WheelScrollUp".focus-column-left = {};
      "Mod+Ctrl+Shift+WheelScrollDown".move-column-right = {};
      "Mod+Ctrl+Shift+WheelScrollUp".move-column-left = {};
  
      # Workspace by index
      "Mod+1".focus-workspace = 1;
      "Mod+2".focus-workspace = 2;
      "Mod+3".focus-workspace = 3;
      "Mod+4".focus-workspace = 4;
      "Mod+5".focus-workspace = 5;
      "Mod+6".focus-workspace = 6;
      "Mod+7".focus-workspace = 7;
      "Mod+8".focus-workspace = 8;
      "Mod+9".focus-workspace = 9;
      "Mod+Ctrl+1".move-column-to-workspace = 1;
      "Mod+Ctrl+2".move-column-to-workspace = 2;
      "Mod+Ctrl+3".move-column-to-workspace = 3;
      "Mod+Ctrl+4".move-column-to-workspace = 4;
      "Mod+Ctrl+5".move-column-to-workspace = 5;
      "Mod+Ctrl+6".move-column-to-workspace = 6;
      "Mod+Ctrl+7".move-column-to-workspace = 7;
      "Mod+Ctrl+8".move-column-to-workspace = 8;
      "Mod+Ctrl+9".move-column-to-workspace = 9;
  
      # Columns / windows
      "Mod+BracketLeft".consume-or-expel-window-left = {};
      "Mod+BracketRight".consume-or-expel-window-right = {};
      "Mod+Comma".consume-window-into-column = {};
      "Mod+Period".expel-window-from-column = {};
  
      "Mod+R".switch-preset-column-width = {};
      "Mod+Shift+R".switch-preset-window-height = {};
      "Mod+Ctrl+R".reset-window-height = {};
      "Mod+F".maximize-column = {};
      "Mod+Shift+F".fullscreen-window = {};
      "Mod+Ctrl+F".expand-column-to-available-width = {};
  
      "Mod+C".center-column = {};
      "Mod+Ctrl+C".center-visible-columns = {};
  
      "Mod+Minus".set-column-width = "-10%";
      "Mod+Equal".set-column-width = "+10%";
      "Mod+Shift+Minus".set-window-height = "-10%";
      "Mod+Shift+Equal".set-window-height = "+10%";
  
      "Mod+V".toggle-window-floating = {};
      "Mod+Shift+V".switch-focus-between-floating-and-tiling = {};
  
      "Mod+W".toggle-column-tabbed-display = {};
  
      # Screenshots
      "Print".screenshot = {};
      "Ctrl+Print".screenshot-screen = {};
      "Alt+Print".screenshot-window = {};
  
      "Mod+Escape" = {
        _props.allow-inhibiting = false;
        toggle-keyboard-shortcuts-inhibit = {};
      };
  
      # Session
      "Mod+Shift+E".quit = {};
      "Ctrl+Alt+Delete".quit = {};
  
      "Mod+Alt+S" = {
        _props.allow-when-locked = true;
        spawn = ["systemctl" "suspend"];
      };
      "Mod+Alt+R" = {
        _props.allow-when-locked = true;
        spawn = ["systemctl" "reboot"];
      };
      "Mod+Alt+P" = {
        _props.allow-when-locked = true;
        spawn = ["systemctl" "poweroff"];
      };
  
      "Mod+Shift+P".power-off-monitors = {};
    };
  
    # Repeated / parameterized top-level nodes
    _children = [
      # Outputs
      {
        output = {
          _args = ["DP-3"];
          scale = 1.5;
          transform = "normal";
          position._props = { x = 0; y = 0; };
        };
      }
      {
        output = {
          _args = ["HDMI-A-1"];
          off = {};
        };
      }
  
      # Startup
      #{ spawn-at-startup = ["app2unit" "--" "waybar" "-c" "/home/paul/.config/waybar/config-niri.jsonc"]; }
      #{ spawn-at-startup = ["app2unit" "--" "swaybg" "-i" "/home/paul/wallpaper"]; }
      #{ spawn-at-startup = ["app2unit" "--" "wlsunset" "-l" "51.041766829771085" "-L" "5.8570853075802"]; }
      #{ spawn-at-startup = ["app2unit" "--" "chromium"]; }
      #{ spawn-at-startup = ["app2unit" "--" "syncthingtray" "--wait"]; }
      #{
      #  spawn-at-startup = [
      #    "app2unit" "--" "swayidle" "-w"
      #    "timeout" "600" "app2unit -- hyprlock &"
      #    "timeout" "601" "niri msg action power-off-monitors"
      #    "resume" "niri msg action power-on-monitors"
      #    "before-sleep" "hyprlock &"
      #  ];
      #}
  
      # Window rules
      # Work around WezTerm's initial configure bug.
      {
        window-rule._children = [
          { match._props.app-id = "^org\\.wezfurlong\\.wezterm$"; }
          { default-column-width = {}; }
        ];
      }
  
      # Open the Firefox picture-in-picture player as floating by default.
      {
        window-rule._children = [
          { match._props = { app-id = "firefox$"; title = "^Picture-in-Picture$"; }; }
          { open-floating = true; }
        ];
      }
  
      # Open RingCentral popups floating.
      {
        window-rule._children = [
          { match._props = { app-id = "chromium"; title = "^RingCentral phone call"; }; }
          { match._props = { app-id = "chromium"; title = "^about:blank"; }; }
          { default-column-width.fixed = 320; }
          { default-window-height.fixed = 550; }
          { open-floating = true; }
        ];
      }
  
      # Auto maximize freerdp for comsol.
      {
        window-rule._children = [
          { match._props = { app-id = "com.freerdp.client.sdl3"; title = "FreeRDP: psaldenws1"; }; }
          { open-maximized = true; }
          { open-floating = false; }
        ];
      }
    ];
  };
}
