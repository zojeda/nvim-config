-- Look and feel: VS Code theme, editor tabs, status bar, shortcut hints.
local nerd = vim.g.have_nerd_font

return {
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("vscode").setup({ italic_comments = true })
      vim.cmd.colorscheme("vscode")
    end,
  },

  { "nvim-tree/nvim-web-devicons", lazy = true, enabled = nerd },

  -- Open files as tabs along the top
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    keys = {
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next tab" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous tab" },
      { "<C-PageDown>", "<cmd>BufferLineCycleNext<cr>", desc = "Next tab" },
      { "<C-PageUp>", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous tab" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Close other tabs" },
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Pin tab" },
    },
    opts = function()
      local options = {
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
        close_command = function(buf)
          require("config.util").close_buffer(buf)
        end,
        right_mouse_command = function(buf)
          require("config.util").close_buffer(buf)
        end,
        offsets = {
          { filetype = "neo-tree", text = "EXPLORER", text_align = "left", separator = true },
        },
      }
      if not nerd then
        options.show_buffer_icons = false
        options.buffer_close_icon = "x"
        options.close_icon = "x"
        options.modified_icon = "●"
        options.left_trunc_marker = "<"
        options.right_trunc_marker = ">"
      end
      return { options = options }
    end,
  },

  -- Status bar with branch, change counts and problems
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "vscode",
        globalstatus = true,
        icons_enabled = nerd,
        component_separators = "",
        section_separators = "",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      extensions = { "neo-tree", "lazy", "mason", "quickfix" },
    },
  },

  -- Shows the available shortcuts after pressing <Space> (or any prefix)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      icons = {
        mappings = nerd,
        breadcrumb = ">>",
        separator = "->",
        group = "+",
        keys = nerd and {} or {
          Up = "<Up> ",
          Down = "<Down> ",
          Left = "<Left> ",
          Right = "<Right> ",
          C = "<C-…> ",
          M = "<M-…> ",
          D = "<D-…> ",
          S = "<S-…> ",
          CR = "<CR> ",
          Esc = "<Esc> ",
          ScrollWheelDown = "<ScrollWheelDown> ",
          ScrollWheelUp = "<ScrollWheelUp> ",
          NL = "<NL> ",
          BS = "<BS> ",
          Space = "<Space> ",
          Tab = "<Tab> ",
          F1 = "<F1>",
          F2 = "<F2>",
          F3 = "<F3>",
          F4 = "<F4>",
          F5 = "<F5>",
          F6 = "<F6>",
          F7 = "<F7>",
          F8 = "<F8>",
          F9 = "<F9>",
          F10 = "<F10>",
          F11 = "<F11>",
          F12 = "<F12>",
        },
      },
      spec = {
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>b", group = "tabs" },
        { "<leader>c", group = "code" },
      },
    },
  },
}
