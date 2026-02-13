return {
	{
		"metalelf0/black-metal-theme-neovim",
		lazy = false,
		priority = 1000,
		config = function()
			require("black-metal").setup({
				theme = "bathory",
				variant = "dark",
				transparent = true,
				plain_float = true,
				dark_gutter = false,
			})

			require("black-metal").load()
			vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "none" })
			vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "none" })
		end,
	},
}


-- return {
-- 	{
-- 		"catppuccin/nvim",
-- 		name = "catppuccin",
-- 		priority = 1000,
-- 		lazy = false,
-- 		config = function()
-- 			require("catppuccin").setup({
-- 				transparent_background = true,
-- 				float = {
-- 					transparent = true,
-- 				},
-- 				custom_highlights = {
-- 					FloatBorder = { link = "NonText" },
-- 				},
-- 			})
--
-- 			vim.cmd.colorscheme("catppuccin-mocha")
-- 			vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "none" })
-- 			vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "none" })
-- 		end,
-- 	},
-- }
