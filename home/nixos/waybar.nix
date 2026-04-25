{ config, pkgs, lib, ... }:

{
  programs.waybar = {
    enable = true;

    settings = [{
      layer    = "top";
      position = "top";
      height   = 32;
      spacing  = 4;

      modules-left   = [ "wlr/taskbar" "wlr/workspaces" ];
      modules-center = [ "clock" ];
      modules-right  = [
        "pulseaudio"
        "bluetooth"
        "network"
        "cpu"
        "memory"
        "temperature"
        "tray"
      ];

      "wlr/workspaces" = {
        format      = "{name}";
        on-click    = "activate";
        sort-by-name = true;
      };

      "wlr/taskbar" = {
        format          = "{icon}";
        icon-size       = 16;
        tooltip-format  = "{title}";
        on-click        = "activate";
        on-click-middle = "close";
      };

      clock = {
        timezone  = "Asia/Tokyo";
        format    = " {:%a %d %b  %H:%M}";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      };

      cpu = {
        format   = " {usage}%";
        tooltip  = true;
        interval = 5;
      };

      memory = {
        format   = " {percentage}%";
        tooltip-format = "{used:0.1f}G / {total:0.1f}G";
        interval = 10;
      };

      temperature = {
        critical-threshold = 80;
        format             = " {temperatureC}°C";
        format-critical    = " {temperatureC}°C";
      };

      pulseaudio = {
        format         = "{icon} {volume}%";
        format-muted   = " muted";
        format-icons   = { default = [ "" "" "" ]; };
        on-click       = "pavucontrol";
        scroll-step    = 5;
      };

      bluetooth = {
        format          = " {status}";
        format-connected = " {device_alias}";
        format-off      = "";
        tooltip-format  = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
        tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
        tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
        on-click        = "blueman-manager";
      };

      network = {
        format-wifi         = " {essid} ({signalStrength}%)";
        format-ethernet     = " {ipaddr}";
        format-disconnected = "⚠ Disconnected";
        tooltip-format      = "{ifname}: {ipaddr}/{cidr}";
        on-click            = "nm-connection-editor";
      };

      tray = {
        spacing = 8;
      };
    }];

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size:   13px;
        min-height:  0;
      }

      window#waybar {
        background-color: rgba(30, 30, 46, 0.90);  /* Catppuccin Mocha base */
        color:            #cdd6f4;
        border-bottom:    2px solid #313244;
      }

      .modules-left,
      .modules-center,
      .modules-right {
        padding: 0 8px;
      }

      #workspaces button {
        padding:     0 6px;
        color:       #6c7086;
        background:  transparent;
        border:      none;
        border-radius: 4px;
      }

      #workspaces button:hover {
        background: #313244;
        color:      #cdd6f4;
      }

      #workspaces button.active {
        background: #89b4fa;
        color:      #1e1e2e;
      }

      #taskbar button {
        padding:      0 4px;
        background:   transparent;
        border:       none;
        border-radius: 4px;
        color:        #cdd6f4;
      }

      #taskbar button:hover,
      #taskbar button.active {
        background: #313244;
      }

      #clock,
      #cpu,
      #memory,
      #temperature,
      #pulseaudio,
      #bluetooth,
      #network,
      #tray {
        padding:      0 10px;
        color:        #cdd6f4;
      }

      #clock {
        color: #cba6f7;
      }

      #cpu {
        color: #a6e3a1;
      }

      #memory {
        color: #89b4fa;
      }

      #temperature {
        color: #fab387;
      }

      #temperature.critical {
        color:            #f38ba8;
        animation:        blink 1s linear infinite;
      }

      @keyframes blink {
        to { color: #1e1e2e; background-color: #f38ba8; }
      }

      #pulseaudio {
        color: #f9e2af;
      }

      #pulseaudio.muted {
        color: #6c7086;
      }

      #bluetooth {
        color: #89dceb;
      }

      #bluetooth.off {
        color: #6c7086;
      }

      #network {
        color: #94e2d5;
      }

      #network.disconnected {
        color: #f38ba8;
      }

      #tray {
        color: #cdd6f4;
      }

      tooltip {
        background:   rgba(30, 30, 46, 0.95);
        border:       1px solid #313244;
        border-radius: 6px;
        color:        #cdd6f4;
      }
    '';
  };
}
