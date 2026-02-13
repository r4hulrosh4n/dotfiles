local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
vim.opt.wildignorecase = true
vim.opt.ignorecase = true
vim.opt.smartcase = true


-- this is for autoupdate buffer if it is changed
-- vim.o.autoread = true
-- vim.o.updatetime = 100
-- vim.api.nvim_create_augroup("AutoRead", { clear = true })
-- vim.api.nvim_create_autocmd({ "FocusGained", "CursorHold", "CursorHoldI" }, {
-- 	group = "AutoRead",
-- 	command = "checktime",
-- })

require("options")
require("lazy").setup("plugins")
