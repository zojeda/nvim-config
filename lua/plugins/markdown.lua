-- Markdown opens rendered (headings, tables, lists, code blocks) like a preview.
-- The raw text shows on the cursor line and while typing.
local nerd = vim.g.have_nerd_font

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user_markdown_reading", { clear = true }),
  pattern = "markdown",
  callback = function()
    -- Prose reads better wrapped at word boundaries
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>cm", "<cmd>RenderMarkdown buf_toggle<cr>", ft = "markdown", desc = "Toggle Markdown preview / source" },
      { "<leader>cp", "<cmd>RenderMarkdown preview<cr>", ft = "markdown", desc = "Markdown preview to the side" },
    },
    opts = nerd and {} or {
      heading = { sign = false, icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " } },
      bullet = { icons = { "•", "◦" } },
      checkbox = { unchecked = { icon = "[ ] " }, checked = { icon = "[x] " } },
      code = { sign = false, language_icon = false },
      link = { enabled = false },
    },
  },
}
