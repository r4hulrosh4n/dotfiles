return {
	"stevearc/oil.nvim",
	opts = {},
	dependencies = { "nvim-tree/nvim-web-devicons" }, -- use nvim-web-devicons for icons
	lazy = false,
	config = function()
		local oil = require("oil")
		oil.setup({
			view_options = { show_hidden = true },
			float = {
				border = "rounded",
				padding = 1,
				max_width = 0.8,
				max_height = 0.8,
				override = function(conf)
					local width = math.floor(vim.o.columns * 0.8)
					local height = math.floor(vim.o.lines * 0.8)
					conf.width = width
					conf.height = height
					conf.row = math.floor((vim.o.lines - height) / 2 - 1)
					conf.col = math.floor((vim.o.columns - width) / 2)
					return conf
				end,
				win_options = { winblend = 0 },
			},
		})

		vim.keymap.set("n", "-", oil.toggle_float, {})
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "oil",
			callback = function(ev)
				vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", { buffer = ev.buf, silent = true })
			end,
		})
	end,
}
