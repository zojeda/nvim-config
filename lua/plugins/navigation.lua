-- Quick open, search in files, symbols and the command palette.
local function pick(name, opts)
  return function()
    require("telescope.builtin")[name](opts)
  end
end

-- File listing for "Go to file": include dotfiles, skip .git, respect .gitignore.
-- fd is called fdfind when installed with apt; ripgrep is the fallback.
local function find_command()
  for _, fd in ipairs({ "fd", "fdfind" }) do
    if vim.fn.executable(fd) == 1 then
      return { fd, "--type", "f", "--hidden", "--exclude", ".git", "--color", "never" }
    end
  end
  if vim.fn.executable("rg") == 1 then
    return { "rg", "--files", "--hidden", "--glob", "!**/.git/*", "--color", "never" }
  end
end

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      { "<C-p>", pick("find_files"), desc = "Go to file" },
      { "<leader>ff", pick("find_files"), desc = "Go to file" },
      { "<leader>fg", pick("live_grep"), desc = "Search in files" },
      { "<leader>fw", pick("grep_string"), mode = { "n", "x" }, desc = "Search word / selection" },
      { "<leader>fb", pick("buffers"), desc = "Open tabs" },
      { "<leader>fr", pick("oldfiles", { cwd_only = true }), desc = "Recent files" },
      { "<leader>fs", pick("lsp_document_symbols"), desc = "Symbols in file" },
      { "<leader>fS", pick("lsp_dynamic_workspace_symbols"), desc = "Symbols in workspace" },
      { "<leader>fd", pick("diagnostics"), desc = "Problems" },
      { "<leader>fc", pick("commands"), desc = "Command palette" },
      { "<leader>fk", pick("keymaps"), desc = "Keyboard shortcuts" },
      { "<leader>fh", pick("help_tags"), desc = "Help" },
      { "<leader>/", pick("current_buffer_fuzzy_find"), desc = "Find in this file" },
      { "<leader>gf", pick("git_status"), desc = "Changed files (picker)" },
      { "<leader>gl", pick("git_commits"), desc = "Commit log" },
      { "<leader>gw", pick("git_branches"), desc = "Switch branch" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          sorting_strategy = "ascending",
          layout_config = { prompt_position = "top" },
          path_display = { "truncate" },
          mappings = {
            i = {
              ["<Esc>"] = actions.close,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            },
          },
        },
        pickers = {
          find_files = { find_command = find_command() },
          buffers = { sort_mru = true, ignore_current_buffer = true },
        },
      })

      pcall(telescope.load_extension, "fzf")
    end,
  },
}
