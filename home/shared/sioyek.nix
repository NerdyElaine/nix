{ pkgs, ... }:
{
  programs.sioyek = {
        enable = true;
        config = {
            "background_color" = "#F3EAD3";  

            "text_highlight_color" =  "#A7C080"; 
            "visual_mark_color" = "#E1E4BD";

            "search_highlight_color" = "#A7C080";
            "link_highlight_color" = "#7FBBB3";
            "synctex_highlight_color" = "#EBCB8B";

            "highlight_color_a" =  "#A7C080"; 
            "highlight_color_b" =  "#EBCB8B";
            "highlight_color_c" =  "#7FBBB3";
            "highlight_color_d" =  "#E8A2AF";
            "highlight_color_e" =  "#D3C6AA";
            "highlight_color_f" =  "#D08770";
            "highlight_color_g" =  "#A7C080";

            "custom_background_color"= "#FAF4ED";
            "custom_text_color" = "#434C5E";

            "ui_text_color" = "#434C5E";
            "ui_background_color" = "#ECEFF4";
            "ui_selected_text_color" = "#434C5E";
            "ui_selected_background_color" = "#D8DEE9";

            "super_fast_search" = "1";

            "page_separator_width" = "10";
            "ui_font" =  "Iosevka Nerd Font";
            startup_commands = [
                "toggle_custom_color"
            ];
            };
         bindings = {
            "move_right" = "m";
            "move_down" =  "n";
            "move_up" = "e";
            "move_left" = "i";
            "screen_up" = "<C-l>";
            "screen_down" = "<C-s>";
            "synctex_under_cursor" = "H";
            "toggle_statusbar" = "S";
            "toggle_synctex" =  "L";
            "toggle_two_page_mode" = "D";
            "zoom_in" = "E";
            "zoom_out" = "N";
            "fit_to_page_width" =  "r";
            "toggle_titlebar" =  "<C-w>";
            "toggle_fullscreen" = "<C-t>";
             };
  };
}
