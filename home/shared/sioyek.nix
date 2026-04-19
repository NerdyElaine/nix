{pkgs, ...}: {
  programs.sioyek = {
    enable = true;
    config = {
      "background_color" = "0 0 0"; # #F3EAD3
      "text_highlight_color" = "0.655 0.753 0.502"; # #A7C080
      "visual_mark_color" = "0.882 0.894 0.741"; # #E1E4BD
      "search_highlight_color" = "0.655 0.753 0.502"; # #A7C080
      "link_highlight_color" = "0.498 0.733 0.702"; # #7FBBB3
      "synctex_highlight_color" = "0.922 0.796 0.545"; # #EBCB8B

      "highlight_color_a" = "0.655 0.753 0.502"; # #A7C080
      "highlight_color_b" = "0.922 0.796 0.545"; # #EBCB8B
      "highlight_color_c" = "0.498 0.733 0.702"; # #7FBBB3
      "highlight_color_d" = "0.910 0.635 0.686"; # #E8A2AF
      "highlight_color_e" = "0.827 0.776 0.667"; # #D3C6AA
      "highlight_color_f" = "0.816 0.529 0.439"; # #D08770
      "highlight_color_g" = "0.655 0.753 0.502"; # #A7C080

      "custom_background_color" = "0.153 0.180 0.200"; # #FAF4ED
      "custom_text_color" = "0.827 0.776 0.667"; # #434C5E
      "status_bar_color" = "0.153 0.180 0.200";

      "ui_text_color" = "0.827 0.776 0.667"; # #434C5E
      "ui_background_color" = "0.153 0.180 0.200"; # #ECEFF4
      "ui_selected_text_color" = "0.263 0.298 0.369"; # #434C5E
      "ui_selected_background_color" = "0.655 0.753 0.502"; # #D8DEE9
      "super_fast_search" = "1";
      "page_separator_width" = "0";
      "ui_font" = "Iosevka Nerd Font";

      startup_commands = [
        "toggle_custom_color"
        "toggle_titlebar"
      ];
    };
    bindings = {
      "move_right" = "m";
      "move_down" = "n";
      "move_up" = "e";
      "move_left" = "i";
      "screen_up" = "<C-l>";
      "screen_down" = "<C-s>";
      "synctex_under_cursor" = "H";
      "toggle_statusbar" = "S";
      "toggle_synctex" = "L";
      "toggle_two_page_mode" = "D";
      "zoom_in" = "E";
      "toggle_custom_color" = "C";
      "zoom_out" = "N";
      "fit_to_page_width" = "r";
      "toggle_titlebar" = "<C-w>";
      "toggle_fullscreen" = "<C-t>";
    };
  };
}
