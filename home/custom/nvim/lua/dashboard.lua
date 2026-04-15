local alpha = require('alpha')
local dashboard = require("alpha.themes.dashboard")
dashboard.section.header.val = {


	[[  ^  ^  ^   ^☆ ★ ☆ ___I_☆ ★ ☆ ^  ^   ^  ^  ^   ^  ^ ]],
	[[ /|\/|\/|\ /|\ ★☆ /\-_--\ ☆ ★/|\/|\ /|\/|\/|\ /|\/|\ ]],
	[[ /|\/|\/|\ /|\ ★ /  \_-__\☆ ★/|\/|\ /|\/|\/|\ /|\/|\ ]],
	[[ /|\/|\/|\ /|\ 󰻀 |[]| [] | 󰻀 /|\/|\ /|\/|\/|\ /|\/|\ ]],
}

dashboard.section.buttons.val = {
	dashboard.button("t", "󰱽 Find file",function() Snacks.picker.files() end),
	dashboard.button("k", "  New file", ":ene <BAR> startinsert <CR>"),
	dashboard.button("n", "󱞁 Notes", function() require("telescope-orgmode").search_headings({ mode = "orgfiles" }) end),
	dashboard.button("c", " Config", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end),
	dashboard.button("s", "󰯂 Browse Scripts", function() Snacks.picker.files({cwd = "~/dotfiles/scripts/"}) end),
	dashboard.button("q", "󰅙  Quit", ":q!<CR>"),
}

dashboard.section.footer.val = function()
  return vim.g.startup_time_ms or "[[  ]]"
end

dashboard.section.buttons.opts.hl = "Keyword"
dashboard.opts.opts.noautocmd = true
alpha.setup(dashboard.opts)
