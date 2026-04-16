{ config, pkgs, ... }:
{
  programs.waybar = {
  enable = true;

  settings = {
    mainBar = {
      layer = "top";
      position = "top";
      height = 30;

      modules-left = [ "clock" ];
      modules-center = [ "cpu" ];
      modules-right = [ "memory" "network" "pulseaudio" "battery" ];

      clock = {
        format = "{:%H:%M}";
        tooltip-format = "{:%A, %d %B %Y}";
      };

      cpu = {
        format = " {usage}%";
      };

      memory = {
        format = " {}%";
      };

      network = {
        format-wifi = " {essid}";
        format-ethernet = "󰈀 Wired";
        format-disconnected = "⚠ Disconnected";
        tooltip-format = "{ipaddr}";
      };

      pulseaudio = {
        format = " {volume}%";
        format-muted = " muted";
      };

      battery = {
        format = " {capacity}%";
        format-charging = " {capacity}%";
        states = {
          warning = 30;
          critical = 15;
        };
      };
    };
  };

  style = ''
    * {
      border: none;
      border-radius: 0;
      font-family: monospace;
      font-size: 12px;
      min-height: 0;
    }

    window#waybar {
      background: #1e1e2e;
      color: #cdd6f4;
    }

    #clock, #cpu, #memory, #network, #pulseaudio, #battery {
      padding: 0 10px;
    }

    #clock {
      font-weight: bold;
    }

    #battery.warning {
      color: #f9e2af;
    }

    #battery.critical {
      color: #f38ba8;
    }
  '';
};
}
