{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    # Specialized options for Waybar main configuration
    settings = {
      mainBar = {
        spacing = 4;
        
        modules-left = [
          "niri/workspaces"
        ];
        
        modules-center = [
          "niri/window"
        ];
        
        modules-right = [
          "group/hardware"
          "custom/weather"
          "tray"
          "clock"
          "group/volume"
          "custom/power"
        ];

        # Module definitions
        "niri/workspaces" = {
          format = "{icon}";
          format-icons = {
            active = "";
            default = "";
          };
        };

        "group/hardware" = {
          orientation = "inherit";
          modules = [ "cpu" "memory" "temperature" ];
        };

        "group/volume" = {
          orientation = "horizontal";
          drawer = {
            transition-duration = 300;
            transition-left-to-right = false;
            click-to-reveal = true;
          };
          modules = [
            "pulseaudio"
            "custom/pavucontrol"
            "custom/audioswitch"
            "pulseaudio/slider"
          ];
        };

        "keyboard-state" = {
          numlock = true;
          capslock = true;
          format = "{name} {icon}";
          format-icons = {
            locked = "";
            unlocked = "";
          };
        };

        "sway/mode" = {
          format = "<span style=\"italic\">{}</span>";
        };

        "sway/scratchpad" = {
          format = "{icon} {count}";
          show-empty = false;
          format-icons = [ "" "" ];
          tooltip = true;
          tooltip-format = "{app}: {title}";
        };

        "mpd" = {
          format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% ";
          format-disconnected = "Disconnected ";
          format-stopped = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
          unknown-tag = "N/A";
          interval = 5;
          consume-icons = {
            on = " ";
          };
          random-icons = {
            off = "<span color=\"#f53c3c\"></span> ";
            on = " ";
          };
          repeat-icons = {
            on = " ";
          };
          single-icons = {
            on = "1 ";
          };
          state-icons = {
            paused = "";
            playing = "";
          };
          tooltip-format = "MPD (connected)";
          tooltip-format-disconnected = "MPD (disconnected)";
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };

        "tray" = {
          spacing = 10;
        };

        "clock" = {
          tooltip-format = "{calendar}";
          format-alt = "{:%Y-%m-%d}";
          calendar = {
            format = {
              months = "<span size='larger' weight='ultrabold'>{}</span>";
              today = "<u>{}</u>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };

        "cpu" = {
          format = "{usage}% ";
          tooltip = false;
        };

        "memory" = {
          format = "{}% ";
        };

        "temperature" = {
          hwmon-path = "/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon2/temp1_input";
          critical-threshold = 80;
          format = "{temperatureC}°C {icon}";
          format-icons = [ "󱃃" "" "" ];
        };

        "backlight" = {
          format = "{percent}% {icon}";
          format-icons = [ "" "" "" "" "" "" "" "" "" ];
        };

        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-full = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = [ "" "" "" "" "" ];
        };

        "battery#bat2" = {
          bat = "BAT2";
        };

        "power-profiles-daemon" = {
          format = "{icon}";
          tooltip-format = "Power profile: {profile}\nDriver: {driver}";
          tooltip = true;
          format-icons = {
            default = "";
            performance = "";
            balanced = "";
            power-saver = "";
          };
        };

        "network" = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} ";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };

        "pulseaudio" = {
          scroll-step = 5;
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            "alsa_output.pci-0000_0d_00.4.iec958-stereo" = "󰓃";
            "alsa_output.pci-0000_04_00.0.analog-stereo" = "󰋎";
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
          reverse-mouse-scrolling = true;
        };

        "custom/media" = {
          format = "{icon} {text}";
          return-type = "json";
          max-length = 40;
          format-icons = {
            spotify = "";
            default = "🎜";
          };
          escape = true;
          exec = "$HOME/.config/waybar/mediaplayer.py";
        };

        "wireplumber" = {
          format = "{volume}% {icon} ";
          format-muted = " ";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            default = [ "" "" "" "" ];
          };
          max-volume = 150;
          scroll-step = 5;
          tooltip-format = "{node_name}\r{volume}% {icon}  {format_source}";
        };

        "custom/weather" = {
          format = "{}";
          interval = 1800;
          exec = "~/.config/waybar/scripts/weather.sh";
          tooltip = false;
          on-click = "xdg-open 'https://wttr.in/~Kasselemeier,Nieuwstadt'";
        };

        "wlr/taskbar" = {
          format = "{icon}";
          tooltip-format = "{title}";
          sort-by-app-id = true;
          on-click = "activate";
          on-click-middle = "close";
        };

        "pulseaudio/slider" = {
          min = 0;
          max = 100;
          orientation = "horizontal";
        };

        "backlight/slider" = {
          min = 0;
          max = 100;
          orientation = "horizontal";
        };

        "custom/audioswitch" = {
          format = "{}";
          exec = "~/.config/waybar/scripts/toggle_audio.sh --listen";
          on-click = "~/.config/waybar/scripts/toggle_audio.sh --switch";
          tooltip = false;
        };

        "custom/pavucontrol" = {
          format = "󰒓 ";
          on-click = "pwvucontrol";
          tooltip = false;
        };

        "custom/power" = {
          format = "⏻ ";
          tooltip = false;
          menu = "on-click";
          menu-file = "$HOME/.config/waybar/power_menu.xml";
          menu-actions = {
            shutdown = "systemctl poweroff";
            reboot = "systemctl reboot";
            suspend = "systemctl suspend";
            hibernate = "systemctl hibernate";
            logout = "niri msg action quit";
          };
        };
      };
    };

    # Specialized option for Waybar GTK styling
    style = ''
      /* Warm Neutral Color Palette */
      @define-color primary #b39a8b;
      @define-color on_primary #211a17;
      @define-color primary_container #4d4039;
      @define-color on_primary_container #d9c8be;

      @define-color secondary #aaa099;
      @define-color on_secondary #1d1a18;
      @define-color secondary_container #403b38;
      @define-color on_secondary_container #d0c6c0;

      @define-color tertiary #a5a38f;
      @define-color on_tertiary #191915;
      @define-color tertiary_container #3d3d35;
      @define-color on_tertiary_container #c9c8b4;

      @define-color error #c97975;
      @define-color on_error #2a1110;
      @define-color error_container #612d2b;
      @define-color on_error_container #e9b7b3;

      @define-color background #181716;
      @define-color on_background #e1ddda;

      @define-color surface #181716;
      @define-color on_surface #e1ddda;
      @define-color surface_container #252321;

      @define-color outline #8f8985;
      @define-color outline_variant #484441;

      @define-color inactive_module_color #8d8783;

      * {
          font-family: "JetBrainsMono Nerd Font";
          font-size: 13px;
          font-weight: bold;
          box-shadow: none;
          border: none;
          text-shadow: none;
      }

      window#waybar {
          background-color: alpha(@background, 0.7);
          color: @on_surface;
          transition: background-color 0.5s;
      }

      #clock,
      #battery,
      #taskbar,
      #hardware,
      #volume,
      #network,
      #tray,
      #idle_inhibitor,
      #submap,
      #custom-weather,
      #language,
      #keyboard-state,
      #custom-power,
      #workspaces {
          padding: 0 12px;
          margin: 4px 3px;
          background-color: @surface_container;
          color: @secondary;
          border-radius: 10px;
      }

      #workspaces button {
          padding: 0 10px;
          color: @on_surface_variant;
          transition: all 0.2s ease-in-out;
      }

      #workspaces button:hover {
          color: @tertiary;
      }

      #workspaces button.active,
      #workspaces button.focused {
          color: @primary;
      }

      #workspaces button.urgent {
          background-color: @error;
          color: @on_error;
      }

      #cpu {
          padding-right: 6px;
      }
      #memory {
          padding: 0px 6px;
      }
      #temperature {
          padding-left: 6px;
      }

      #clock {
          color: @tertiary;
          font-weight: bolder;
      }
      #volume,
      #custom-power {
          color: @primary;
      }

      @keyframes blink {
          to {
              background-color: @error;
              color: @on_error;
          }
      }

      #battery.critical:not(.charging) {
          background-color: @error;
          color: @on_error;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      #pulseaudio.muted,
      #network.disconnected {
          color: @outline;
      }

      tooltip {
          background-color: @surface;
          border: 1px solid @outline;
          border-radius: 12px;
      }

      tooltip label {
          color: @on_surface;
          padding: 8px;
      }

      menu {
          background: @surface;
          border: 1px solid @outline;
          border-radius: 12px;
          padding: 4px;
      }

      menuitem {
          color: @on_surface;
          padding: 6px 12px;
      }

      menuitem:hover {
          background: @primary;
          color: @surface;
      }

      #pulseaudio-slider slider,
      #backlight-slider slider {
          min-height: 0px;
          min-width: 0px;
          opacity: 0;
          background-image: none;
          border: none;
          box-shadow: none;
          padding: 0px;
      }

      #pulseaudio-slider trough,
      #backlight-slider trough {
          min-height: 8px;
          min-width: 80px;
          border-radius: 4px;
          background: @on_primary;
          margin: 0 10px;
      }

      #pulseaudio-slider highlight,
      #backlight-slider highlight {
          min-height: 8px;
          border-radius: 4px;
          background: @primary;
      }
    '';
  };

  # Auxiliary Files Deployment
  xdg.configFile = {
    "waybar/power_menu.xml".text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <interface>
        <object class="GtkMenu" id="menu">
          <child>
            <object class="GtkMenuItem" id="suspend">
              <property name="label">Suspend</property>
            </object>
          </child>
          <child>
            <object class="GtkMenuItem" id="hibernate">
              <property name="label">Hibernate</property>
            </object>
          </child>
          <child>
            <object class="GtkMenuItem" id="shutdown">
              <property name="label">Shutdown</property>
            </object>
          </child>
          <child>
            <object class="GtkMenuItem" id="logout">
              <property name="label">Log out</property>
            </object>
          </child>
          <child>
            <object class="GtkSeparatorMenuItem" id="delimiter1"/>
          </child>
          <child>
            <object class="GtkMenuItem" id="reboot">
              <property name="label">Reboot</property>
            </object>
          </child>
        </object>
      </interface>
    '';

    "waybar/scripts/weather.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash

        URL="https://wttr.in/~Kasselemeier,Nieuwstadt?format=%c%t"
        MAX_RETRIES=3
        attempt=0

        while [ $attempt -le $MAX_RETRIES ]; do
            response=$(${pkgs.curl}/bin/curl -s --connect-timeout 5 "$URL")
            
            if [ $? -eq 0 ] && [ -n "$response" ] && [[ "$response" != *"<html>"* ]] && [[ "$response" != *"Unknown"* ]]; then
                echo "$response"
                exit 0
            fi
            
            attempt=$((attempt + 1))
            
            if [ $attempt -le $MAX_RETRIES ]; then
                sleep 5
            fi
        done

        echo "Weather N/A"
        exit 1
      '';
    };

    "waybar/scripts/toggle_audio.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash

        set -u

        sink_id() {
            ${pkgs.wireplumber}/bin/wpctl status --name |
                ${pkgs.gawk}/bin/awk -v name="$1" '
                    /├─ Sinks:/   { in_sinks=1; next }
                    /├─ Sources:/ { in_sinks=0 }
                    in_sinks && $0 ~ name {
                        for (i = 1; i <= NF; i++) {
                            if ($i ~ /^[0-9]+\.$/) {
                                gsub(/\./, "", $i)
                                print $i
                                exit
                            }
                        }
                    }
                '
        }

        default_name() {
            ${pkgs.wireplumber}/bin/wpctl inspect @DEFAULT_SINK@ 2>/dev/null |
                ${pkgs.gawk}/bin/awk -F'"' '/node.name/ { print $2; exit }'
        }

        print_status() {
            case "$(default_name)" in
                *iec958*) echo "󰓃" ;;
                *analog*) echo "󰋎" ;;
                *)        echo "" ;;
            esac
        }

        switch_sink() {
            local iec_sink analog_sink current

            iec_sink=$(sink_id 'iec958')
            analog_sink=$(sink_id 'analog')
            current=$(default_name)

            if [[ "$current" == *iec958* ]]; then
                [[ -n "$analog_sink" ]] && ${pkgs.wireplumber}/bin/wpctl set-default "$analog_sink"
            elif [[ "$current" == *analog* ]]; then
                [[ -n "$iec_sink" ]] && ${pkgs.wireplumber}/bin/wpctl set-default "$iec_sink"
            fi
        }

        listen() {
            print_status

            ${pkgs.pipewire}/bin/pw-metadata --monitor --name default |
                while IFS= read -r line; do
                    print_status
                done
        }

        case "''${1:-status}" in
            --switch)
                switch_sink
                ;;
            --listen)
                listen
                ;;
            *)
                print_status
                ;;
        esac
      '';
    };
  };
}
