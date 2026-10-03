-- Sidebar: file explorer with git status, plus a "changed files" view.
local nerd = vim.g.have_nerd_font

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = false, -- loads itself lazily; needed so `nvim .` opens the explorer
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<C-b>", "<cmd>Neotree toggle filesystem left<cr>", desc = "Toggle sidebar" },
      { "<leader>e", "<cmd>Neotree focus filesystem left<cr>", desc = "Explorer" },
      { "<leader>ge", "<cmd>Neotree focus git_status left<cr>", desc = "Changed files (sidebar)" },
    },
    opts = function()
      local components = {
        -- Same letters VS Code shows next to changed files
        git_status = {
          symbols = {
            added = "A",
            modified = "M",
            deleted = "D",
            renamed = "R",
            untracked = "U",
            ignored = "",
            unstaged = "",
            staged = "✓",
            conflict = "!",
          },
        },
      }
      if not nerd then
        components.icon = {
          folder_closed = "▸",
          folder_open = "▾",
          folder_empty = "▹",
          folder_empty_open = "▿",
          default = " ",
        }
        components.modified = { symbol = "●" }
      end

      return {
        close_if_last_window = true,
        popup_border_style = "rounded",
        sources = { "filesystem", "git_status", "buffers" },
        -- Tabs at the top of the sidebar; switch with < and >
        source_selector = {
          winbar = true,
          content_layout = "center",
          sources = {
            { source = "filesystem", display_name = "Files" },
            { source = "git_status", display_name = "Git" },
            { source = "buffers", display_name = "Open" },
          },
        },
        default_component_configs = components,
        window = {
          width = 34,
          mappings = {
            ["<space>"] = "none", -- keep <Space> free for leader shortcuts
            ["l"] = "open",
            ["h"] = "close_node",
          },
        },
        -- Git tab: Enter (or double-click) shows the change side by side, gf opens the file itself
        git_status = {
          window = {
            mappings = {
              ["<cr>"] = "review_entry",
              ["<2-LeftMouse>"] = "review_entry",
              ["gf"] = "open",
            },
          },
          commands = {
            review_entry = function(state)
              local node = state.tree:get_node()
              if node.type == "file" then
                require("config.util").review_file(node.path)
              else
                require("neo-tree.sources.common.commands").toggle_node(state)
              end
            end,
          },
        },
        filesystem = {
          follow_current_file = { enabled = true },
          use_libuv_file_watcher = true,
          hijack_netrw_behavior = "open_default",
          components = {
            -- Show the workspace folder name instead of its full path
            name = function(config, node, state)
              local result = require("neo-tree.sources.common.components").name(config, node, state)
              if node:get_depth() == 1 and node.type ~= "message" then
                result.text = vim.fn.fnamemodify(node.path, ":t")
              end
              return result
            end,
          },
          filtered_items = {
            visible = true, -- git-ignored files stay visible but dimmed
            hide_dotfiles = false,
            hide_gitignored = true,
            never_show = { ".git", ".DS_Store" },
          },
        },
      }
    end,
  },
}
