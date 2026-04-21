# Mango Wayland compositor — home-manager config
# Requires mango.hmModules.mango imported in home-manager.users.<name>.imports
{ config, pkgs, lib, ... }:

{
  programs.mango.enable = true;

  wayland.windowManager.mango = {
    enable = true;
    settings = ''
      # Appearance 
      border_width        = 2
      border_color        = 0xff89b4fa   # Catppuccin blue
      border_color_focus  = 0xffcba6f7   # Catppuccin mauve
      gap_inner           = 8
      gap_outer           = 10
      corner_radius       = 6
      blur                = true
      shadow              = true

      # Layouts 
      # Available: master-stack | scroller | monocle | grid | deck
      default_layout = master-stack
      master_ratio   = 0.55

      # Input 
      repeat_rate  = 25
      repeat_delay = 300
      tap_to_click = true
      natural_scroll = true

      # Key bindings 
      # Modifier key (Mod4 = Super)
      mod = Mod4

      # Spawn terminal (foot)
      bind = mod+Return        exec foot

      # Launcher (wmenu)
      bind = mod+d             exec wmenu-run-styled

      # Close focused window
      bind = mod+q             killclient

      # Reload config
      bind = mod+Shift+r       reload

      # Quit compositor
      bind = mod+Shift+q       quit

      # Layout cycling
      bind = mod+space         next_layout
      bind = mod+Shift+space   prev_layout

      # Focus movement
      bind = mod+h             focusleft
      bind = mod+l             focusright
      bind = mod+j             focusdown
      bind = mod+k             focusup

      # Window movement
      bind = mod+Shift+h       moveleft
      bind = mod+Shift+l       moveright
      bind = mod+Shift+j       movedown
      bind = mod+Shift+k       moveup

      # Master ratio
      bind = mod+equal         incmaster
      bind = mod+minus         decmaster

      # Tags 1–9
      bind = mod+1             viewtag 1
      bind = mod+2             viewtag 2
      bind = mod+3             viewtag 3
      bind = mod+4             viewtag 4
      bind = mod+5             viewtag 5
      bind = mod+Shift+1       tagtag 1
      bind = mod+Shift+2       tagtag 2
      bind = mod+Shift+3       tagtag 3
      bind = mod+Shift+4       tagtag 4
      bind = mod+Shift+5       tagtag 5

      # Screenshots (grim + slurp)
      bind = mod+p             exec grim ~/Pictures/screenshot-$(date +%F_%T).png
      bind = mod+Shift+p       exec grim -g "$(slurp)" ~/Pictures/screenshot-$(date +%F_%T).png
    '';

    # autostart.sh 
    autostart_sh = ''
      swaybg -i ~/nix/home/custom/Wallpaper/flower.jpg -m fill &
      mango-wc &
    '';
  };
}
