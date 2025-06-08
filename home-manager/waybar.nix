{ config, pkgs, lib, ... }:

{
  home.file."${config.xdg.configHome}/waybar/config.jsonc" = {
    text =
      builtins.toJSON {
        height = 35;
        spacing = 4;

        modules-left = [
          "systemd-failed-units"
          "custom/music-back"
          "mpris"
          "custom/music-next"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "privacy"
          "pulseaudio"
          "cpu"
          "memory"
          "tray"
          "custom/power"
        ];

        systemd-failed-units = {
          hide-on-ok = true; # Hide if there are zero failed units.
          format = "✗ {nr_failed}";
          format-ok = "✓";
          system = true; # Monitor failed systemwide units.
          user = false; # Ignore failed user units.
        };
        "custom/music-back" = {
          format = "⏴";
          tooltip = true;
          tooltip-format = "Play previous song";
          on-click = "${lib.getExe pkgs.playerctl} previous";
        };
        mpris = {
          format = "{status_icon} {dynamic}";
          dynamic-order = [ "title" "artist" ];
          status-icons = {
            paused = "⏸";
          };
        };
        "custom/music-next" = {
          format = "⏵";
          tooltip = true;
          tooltip-format = "Play next song";
          on-click = "${lib.getExe pkgs.playerctl} next";
        };
        clock = {
          interval = 1;
          format = "{:%a %F %H:%M:%S}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };

        pulseaudio = {
          # "scroll-step": 1, // %, can be a float
          "format" = "{volume}% {icon} {format_source}";
          "format-bluetooth" = "{volume}% {icon} {format_source}";
          "format-bluetooth-muted" = " {icon} {format_source}";
          "format-muted" = " {format_source}";
          "format-source" = "{volume}% ";
          "format-source-muted" = "";
          "format-icons" = {
            "headphone" = "";
            "hands-free" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = [ "" "" "" ];
          };
          "on-click" = lib.getExe pkgs.pavucontrol;
        };
        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };
        memory = {
          format = "{}% ";
        };
        tray = {
          spacing = 10;
        };
        "custom/power" =
          let
            power-menu = pkgs.writeText "power_menu.xml" ''
              <?xml version="1.0" encoding="UTF-8"?>
              <interface>
                <object class="GtkMenu" id="menu">
                  <child>
                    <object class="GtkMenuItem" id="lock">
                      <property name="label">Lock 🔒</property>
                    </object>
                  </child>
                  <child>
                    <object class="GtkSeparatorMenuItem" id="delimiter1"/>
                  </child>
                  <child>
                    <object class="GtkMenuItem" id="reboot">
                      <property name="label">Reboot ♻️</property>
                    </object>
                  </child>
                  <child>
                    <object class="GtkMenuItem" id="poweroff">
                      <property name="label">Poweroff 💤</property>
                    </object>
                  </child>
                </object>
              </interface>
            '';
          in
          {
            "format" = "⏻";
            "tooltip" = false;
            "menu" = "on-click";
            "menu-file" = power-menu;
            "menu-actions" = {
              "lock" = "${lib.getExe pkgs.swaylock}";
              "reboot" = "reboot";
              "poweroff" = "poweroff";
            };
          };
      };
  };
  home.file."${config.xdg.configHome}/waybar/style.css" = {
    text = ''
      ${builtins.readFile ./default-waybar-style.css}

      window#waybar {
        background: linear-gradient(to right,rgb(131, 80, 117) 15%, #e3afd5 30%, rgb(131, 80, 117) 45%, #db88c5);
        color: black;
      }

      #systemd-failed-units {
        padding-left: 30px;
        padding-right: 30px;
        background-color: red;
      }

      #mpris {
        color: white;
      }

      #custom-music-back, #custom-music-next {
        font-size: 20px;
        color: white;
      }

      #custom-music-back {
        padding: 0 10px 0 15px;
      }
      #custom-music-next {
        padding: 0 10px;
      }

      #clock {
        background: unset;
        color: white;
      }

      #privacy *, #pulseaudio, #cpu, #memory, #tray {
        background-color: unset;
        color: black;
      }

      #custom-power {
        padding-left: 15px;
        padding-right: 15px;
        font-size: 30px;
        background-color: rebeccapurple;
        color: white;
      }
    '';
  };
}
