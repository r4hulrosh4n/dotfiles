return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },

    config = function()
      local harpoon = require("harpoon")
      harpoon.setup({
        settings = {
          ui = {
            border = "rounded",
          },
        },
        global_settings = {
          save_on_toggle = false,
          save_on_change = true,
          enter_on_sendcmd = false,
          tmux_autoclose_windows = false,
          excluded_filetypes = { "harpoon" },
          mark_branch = false,
          tabline = false,
          tabline_prefix = "   ",
          tabline_suffix = "   ",
        },
      })

      local list = harpoon:list()

      vim.keymap.set("n", "<leader>a", function()
        list:add()
      end)
      vim.keymap.set("n", "<leader>o", function()
        require("harpoon").ui:toggle_quick_menu(list)
      end)

      vim.keymap.set("n", "<A-h>", function()
        require("harpoon"):list():prev()
      end)

      vim.keymap.set("n", "<A-l>", function()
        require("harpoon"):list():next()
      end)

      vim.keymap.set("n", "<leader>1", function()
        list:select(1)
      end)
      vim.keymap.set("n", "<leader>2", function()
        list:select(2)
      end)
      vim.keymap.set("n", "<leader>3", function()
        list:select(3)
      end)
      vim.keymap.set("n", "<leader>4", function()
        list:select(4)
      end)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "harpoon",
        callback = function()
          local cfg = vim.api.nvim_win_get_config(0)
          cfg.title = "Harpoon"
          cfg.title_pos = "center"
          vim.api.nvim_win_set_config(0, cfg)
          vim.api.nvim_win_set_config(0, {
            border = "rounded",
          })
        end,
      })
    end,
  },
}
