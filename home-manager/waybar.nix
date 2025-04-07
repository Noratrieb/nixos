{ config, ... }: {
  home.file."${config.xdg.configHome}/waybar/config.jsonc" = {
    text =
      builtins.toJSON {
        height = 35;
        spacing = 4;
        modules-left = [ ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "privacy"
          "pulseaudio"
          "cpu"
          "memory"
          "tray"
        ];
        clock = {
          format = "{:%a %F %H:%M}";
          "tooltip-format" = "<tt><small>{calendar}</small></tt>";
          "calendar" = {
            "mode" = "year";
            "mode-mon-col" = 3;
            "weeks-pos" = "right";
            "on-scroll" = 1;
            "format" = {
              "months" = "<span color='#ffead3'><b>{}</b></span>";
              "days" = "<span color='#ecc6d9'><b>{}</b></span>";
              "weeks" = "<span color='#99ffdd'><b>W{}</b></span>";
              "weekdays" = "<span color='#ffcc66'><b>{}</b></span>";
              "today" = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          "actions" = {
            "on-click-right" = "mode";
            "on-scroll-up" = "shift_up";
            "on-scroll-down" = "shift_down";
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
          "on-click" = "pavucontrol";
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

      };
  };
}
