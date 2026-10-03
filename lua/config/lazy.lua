-- Bootstrap lazy.nvim, the plugin manager.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { "Failed to clone lazy.nvim:\n", "ErrorMsg" }, { out, "WarningMsg" } }, true, {})
    return
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = { { import = "plugins" } },
  install = { colorscheme = { "vscode", "habamax" } },
  checker = { enabled = false },
  rocks = { enabled = false }, -- no plugin here needs luarocks
  change_detection = { notify = false },
  ui = {
    border = "rounded",
    icons = vim.g.have_nerd_font and {} or {
      cmd = "[cmd]",
      config = "[config]",
      event = "[event]",
      favorite = "*",
      ft = "[ft]",
      init = "[init]",
      import = "[import]",
      keys = "[keys]",
      lazy = "[lazy] ",
      loaded = "●",
      not_loaded = "○",
      plugin = "[plugin]",
      runtime = "[runtime]",
      require = "[require]",
      source = "[source]",
      start = "[start]",
      task = "[task]",
      list = { "●", "-", "*", "-" },
    },
  },
})
