-- ~/.config/nvim/lua/plugins/lualine.lua
return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local catppuccin = require'lualine.themes.catppuccin'

      -- Customize the theme if necessary
      -- Example: Change the background of lualine_c section for normal mode
      -- custom_catppuccin.normal.c.bg = '#112233'

      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = catppuccin,
          --component_separators = { left = '', right = ''},
          component_separators = { left = '|', right = '|'},
          section_separators = { left = ' ', right = ''},
          -- section_separators = { left = '', right = ''},          

          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          }
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {'filename'},
          -- lualine_c = {'buffers'},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
      }
    end
  }
}

