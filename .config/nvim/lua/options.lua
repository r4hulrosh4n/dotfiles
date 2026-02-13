vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

vim.g.mapleader = " "
vim.g.background = "light"
vim.g.ai_cmp = true
vim.opt.swapfile = false
vim.wo.number = true
vim.wo.relativenumber = true
vim.opt.laststatus = 2


-- Disable horizontal arrow keys to get good at horizontal movement
vim.keymap.set("n", "h", "<Nop>")
vim.keymap.set("n", "l", "<Nop>")

-- Center when half up and down
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Navigate vim panes better
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")
vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = false })
vim.api.nvim_set_keymap("n", "tk", ":blast<enter>", { noremap = false })
vim.api.nvim_set_keymap("n", "tj", ":bfirst<enter>", { noremap = false })
vim.api.nvim_set_keymap("n", "th", ":bprev<enter>", { noremap = false })
vim.api.nvim_set_keymap("n", "tl", ":bnext<enter>", { noremap = false })
vim.api.nvim_set_keymap("n", "td", ":bdelete<enter>", { noremap = false })
vim.api.nvim_set_keymap("n", "vs", ":vsplit<enter>", { noremap = false })
vim.api.nvim_set_keymap("n", "<A-n>", ":set relativenumber! number!<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-y>", '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>r", ":%s///g<Left><Left><Left>", { noremap = true, silent = true }) -- Replace command
vim.api.nvim_set_keymap("n", "<leader>z", ":ZenMode<CR>", { noremap = true, silent = true })
