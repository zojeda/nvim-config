-- VS Code-like Neovim setup.
-- Plugins live in lua/plugins/*.lua and are managed by lazy.nvim (:Lazy).
-- Press <Space> and wait to see every shortcut (which-key).

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- File-type icons in the explorer, tabs and status line need a Nerd Font
-- (https://www.nerdfonts.com) in the terminal. On a device without one,
-- put `export NVIM_NERD_FONT=0` in the shell profile instead of editing this.
vim.g.have_nerd_font = vim.env.NVIM_NERD_FONT ~= "0"

require("config.options")
require("config.keymaps")
require("config.lazy")
