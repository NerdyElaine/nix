{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 24;
        spacing = 0;
        margin = "0";

        modules-left = [
          "wlr/workspaces"
          "custom/layout"
          "river/window"
        ];
        modules-center = [];
        modules-right = [
          "pulseaudio"
          "battery"
          "clock"
        ];

        "wlr/workspaces" = {
          format = "{id}";
          on-click = "activate";
          sort-by-number = true;
        };

        "river/window" = {
          format = "{}";
        };

        "custom/layout" = {
          format = "[]=";
          tooltip = false;
        };

        pulseaudio = {
          format = "vol {volume}%";
          format-muted = "vol muted";
          on-click = "pavucontrol";
        };

        battery = {
          format = "bat {capacity}%";
          format-charging = "bat {capacity}% +";
          format-plugged = "bat {capacity}% =";
          states = {
            warning = 30;
            critical = 15;
          };
        };

        clock = {
          format = "{:%H:%M}";
          tooltip-format = "{:%A, %d %B %Y}";
        };
      };
    };

    style = ''
      * {
        font-family: IosevkaTerm Nerd Font;
        font-size: 12px;
        border: none;
        border-radius: 0;
        min-height: 24px;
        margin: 0;
        padding: 0;
      }

      window#waybar {
        background: #F7F3EE;
        color: #605A52;
      }

      /* workspaces */

      #workspaces button {
        background: #F7F3EE;
        color: #9E9A95;
        padding: 0 10px;
        border: none;
        border-radius: 0;
        box-shadow: none;
        min-width: 28px;
      }

      #workspaces button:hover {
        background: #ECEBE8;
        color: #605A52;
        box-shadow: none;
      }

      #workspaces button.active,
      #workspaces button.focused {
        background: #83577D;
        color: #FCFBF9;
      }

      #workspaces button.urgent {
        background: #8F5652;
        color: #FCFBF9;
      }

      #workspaces button.occupied,
      #workspaces button.visible {
        color: #605A52;
      }

      /* layout indicator */

      #custom-layout {
        color: #9E9A95;
        padding: 0 10px;
        border-right: 1px solid #DDDBD8;
        background: #F7F3EE;
      }

      /* window title */

      #window {
        color: #605A52;
        padding: 0 12px;
        background: #F7F3EE;
      }

      /* right modules */

      #pulseaudio,
      #battery,
      #clock {
        color: #477A7B;
        padding: 0 12px;
        background: #F7F3EE;
        border-left: 1px solid #DDDBD8;
      }

      #clock {
        color: #9E9A95;
      }

      #pulseaudio.muted {
        color: #9E9A95;
      }

      #battery.warning {
        color: #886A44;
      }

      #battery.critical {
        color: #8F5652;
      }
    '';
  };
}
