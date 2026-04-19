{pkgs, ...}: {
  services.neru = {
    enable = true;
    config = ''
      hide_overlay_in_screen_share = true
      center_cursor_position = true

      # Neru Configuration - Recursive Grid Only Mode

      [hotkeys]
      "Option+Return" = "action left_click"
      "Option+Tab" = "scroll"
      "Cmd+Space" = "action move_mouse --center"
      "Option+Escape" = "recursive_grid"

      [recursive_grid.hotkeys]
      "Escape" = "idle"
      "`" = "toggle-cursor-follow-selection"
      "Space" = "action reset"
      "Backspace" = "action backspace"
      "Return" = "action left_click"
      "Shift+Return" = "action right_click"
      "Shift+M" = "action middle_click"
      "Shift+D" = "action mouse_down"
      "Shift+U" = "action mouse_up"
      "Up" = "action move_mouse_relative --dx=0 --dy=-10"
      "Down" = "action move_mouse_relative --dx=0 --dy=10"
      "Left" = "action move_mouse_relative --dx=-10 --dy=0"
      "Right" = "action move_mouse_relative --dx=10 --dy=0"

      [scroll.hotkeys]
      "Escape" = "idle"
      "m" = "action scroll_right"
      "n" = "action scroll_down"
      "e" = "action scroll_up"
      "i" = "action scroll_left"

      [hints]
      enabled = false

      [grid]
      enabled = false

      [recursive_grid]
      enabled = true
      reset_key = ","
      grid_cols = 5
      grid_rows = 5
      keys = "qwfpbarstgdv jluy;mneiokh"

      min_size = 10
      max_depth = 10

      [recursive_grid.animation]
      enabled = false
      duration_ms = 180

      [recursive_grid.ui]
      label_background = false

      highlight_color = "#77BEC5B2"
      text_color = "#FF1E2326"
      line_color = "#FF93B259"
      font_family = "JetBrainsMonoNLNFP-Bold"
      font_size = 12
    '';
  };
}
