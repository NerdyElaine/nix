require("snacks").setup({
    picker = {
        enabled = true,
        matcher = {
            fuzzy = true,
        },
        focus = "input",
        win = {
            input = {
                keys = {
                    ["<Esc>"] = { "close", mode = { "n", "i" } },
                }
            }
        },
        layout = {
            preset = "telescope",
        }
    },
    scroll = { enabled = false },
    animate = { enabled = false },
    image = {
        enabled = true,
        inline = true,
        float = true,
        img_dirs = { "~/Pictures/" },
        doc = {
            enabled = true,
            inline = true,
            float = true,
            max_width = 50,
            max_length = 50,
            scale = 0.8,
            conceal = function(lang, type)
                return type == "math"
            end,
        },
        math = {
            enabled = true,
            packages = { "amsmath", "amssymb", "amsfonts", "amscd", "mathtools" },
            font_size = "tiny",
        },
        convert = {
            magick = {
                math = {
                    "-density", "300",
                    "{src}[{page}]",
                    "-trim",
                    "+repage",
                    "-scale", "100%", -- change to 150, 200, 250, etc.
                },
            },
        },

    },
})
