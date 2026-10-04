-- Code intelligence: syntax highlighting, language servers, completion.
local nerd = vim.g.have_nerd_font

local function pick(name)
  return function()
    require("telescope.builtin")[name]()
  end
end

local function has(cmd)
  return vim.fn.executable(cmd) == 1
end

-- Minimal machines and containers may lack these; skip what cannot be installed
-- instead of failing on every start.
local can_compile = has("cc") or has("gcc") or has("clang")
local headless = #vim.api.nvim_list_uis() == 0

return {
  -- Syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master", -- the `main` branch needs Neovim 0.12+
    build = ":TSUpdate",
    lazy = false,
    main = "nvim-treesitter.configs",
    opts = {
      sync_install = headless, -- lets install.sh finish the parsers before it exits
      ensure_installed = not can_compile and {} or {
        "bash",
        "css",
        "diff",
        "git_rebase",
        "gitcommit",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "rust",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      auto_install = can_compile,
      highlight = { enable = true },
      indent = { enable = true },
    },
  },

  -- Language servers (go to definition, references, rename, problems).
  -- Add more with :Mason; installed servers are enabled automatically.
  { "mason-org/mason.nvim", cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonLog" }, opts = {} },
  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    -- ts_ls is installed with npm
    opts = { ensure_installed = has("npm") and { "ts_ls", "lua_ls" } or { "lua_ls" } },
    config = function(_, opts)
      vim.diagnostic.config({
        severity_sort = true,
        virtual_text = { spacing = 2, source = "if_many" },
        float = { border = "rounded", source = true },
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
            telemetry = { enable = false },
          },
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp_keymaps", { clear = true }),
        callback = function(event)
          local function map(keys, fn, desc, mode)
            vim.keymap.set(mode or "n", keys, fn, { buffer = event.buf, desc = desc })
          end

          map("gd", pick("lsp_definitions"), "Go to definition")
          map("<F12>", pick("lsp_definitions"), "Go to definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("gy", pick("lsp_type_definitions"), "Go to type definition")
          -- grr / gri / grn / gra are Neovim's own defaults; these swap in a picker with preview.
          map("grr", pick("lsp_references"), "Find references")
          map("gri", pick("lsp_implementations"), "Go to implementation")
          map("K", function()
            vim.lsp.buf.hover({ border = "rounded" })
          end, "Hover")
          map("<F2>", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>ca", vim.lsp.buf.code_action, "Quick fix", { "n", "x" })
          map("<leader>cd", vim.diagnostic.open_float, "Show problem on this line")
          map("<leader>cf", function()
            vim.lsp.buf.format({ async = true })
          end, "Format document")
        end,
      })

      require("mason-lspconfig").setup(opts)

      -- Use rustup's rust-analyzer when it is on PATH.
      if vim.fn.executable("rust-analyzer") == 1 then
        vim.lsp.enable("rust_analyzer")
      end
    end,
  },

  -- Completion popup: Tab or Enter accepts, Ctrl+Space opens it
  {
    "saghen/blink.cmp",
    version = "1.*",
    opts = {
      keymap = {
        preset = "super-tab",
        ["<CR>"] = { "accept", "fallback" },
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 300 },
        menu = {
          draw = {
            columns = nerd and { { "kind_icon" }, { "label", "label_description", gap = 1 } }
              or { { "label", "label_description", gap = 1 }, { "kind" } },
          },
        },
      },
      signature = { enabled = true },
    },
  },
}
