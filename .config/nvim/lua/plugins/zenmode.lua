return {
	"folke/zen-mode.nvim",
	opts = {
		window = {
			backdrop = 1, -- Shade the backdrop
			width = 300, -- Adjust width as needed
			height = 1, -- Keep height as 1 line
			options = {
				number = false, -- Disable line numbers
				relativenumber = false, -- Disable relative numbers
				cursorline = false, -- Disable cursor line
				signcolumn = "no", -- Disable sign column
				foldcolumn = "0", -- Disable fold column
			},
		},
		plugins = {
			options = {
				enabled = true,
				ruler = false, -- Disable the ruler text
				showcmd = false, -- Disable the command in the last line
				laststatus = 0, -- Turn off the statusline
			},
			tmux = { enabled = true }, -- Disable tmux statusline
			twilight = { enabled = false }, -- Disable Twilight
			gitsigns = { enabled = false }, -- Disable git signs
			todo = { enabled = false }, -- Disable todo highlights
		},
		on_open = function(win)
			-- Optional: Custom code when Zen mode opens
		end,
		on_close = function()
			-- Optional: Custom code when Zen mode closes
		end,
	},
}
