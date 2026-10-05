-- Git: change markers in the gutter, side-by-side review, staging and commits.
local nerd = vim.g.have_nerd_font

-- Run a git view command from an editor window rather than from the sidebar.
local function from_editor(command)
  return function()
    require("config.util").focus_editor()
    vim.cmd(command)
  end
end

local function toggle_review()
  if require("diffview.lib").get_current_view() then
    vim.cmd.DiffviewClose()
  else
    require("config.util").close_reviews()
    from_editor("DiffviewOpen")()
  end
end

local function git(args)
  local result = vim.system(vim.list_extend({ "git" }, args), { text = true }):wait()
  if result.code == 0 then
    return vim.trim(result.stdout)
  end
end

local function ref_exists(ref)
  return git({ "rev-parse", "--verify", "--quiet", ref .. "^{commit}" }) ~= nil
end

-- The branch this repo's work is reviewed against: the remote's default branch,
-- else the first of main / master / develop that exists.
local function detect_base()
  local candidates = {}
  local remote_head = git({ "symbolic-ref", "--quiet", "--short", "refs/remotes/origin/HEAD" })
  if remote_head then
    vim.list_extend(candidates, { (remote_head:gsub("^origin/", "")), remote_head })
  end
  vim.list_extend(candidates, { "main", "master", "develop", "origin/main", "origin/master", "origin/develop" })
  for _, ref in ipairs(candidates) do
    if ref_exists(ref) then
      return ref
    end
  end
end

-- A base typed here becomes the default for the repo. It is kept in the repo's own
-- git config, so worktrees and dev containers of the same repo share it.
local BASE_KEY = "nvim.reviewbase"

-- Review everything on this branch since it left the base, uncommitted edits included.
local function review_branch()
  if not git({ "rev-parse", "--git-dir" }) then
    vim.notify("Not inside a git repository", vim.log.levels.WARN)
    return
  end

  local default = git({ "config", "--get", BASE_KEY }) or detect_base() or ""
  vim.ui.input({ prompt = "Review this branch against: ", default = default }, function(input)
    input = vim.trim(input or "")
    if input == "" then
      return
    end

    -- A range or extra options are passed to Diffview as typed.
    local advanced = input:find("%s") or input:find("..", 1, true) or input:sub(1, 1) == "-"
    if not advanced and not ref_exists(input) then
      vim.notify(("No branch or commit named '%s'"):format(input), vim.log.levels.WARN)
      return
    end
    if input ~= default then
      git({ "config", "--local", BASE_KEY, input })
    end

    -- --imply-local shows the working files on the right, so they can be edited in place.
    local args = advanced and vim.split(input, "%s+") or { input .. "...HEAD", "--imply-local" }
    local util = require("config.util")
    util.focus_editor()
    util.close_reviews()
    require("diffview").open(args)
  end)
end

-- In a review: close it and open the file under the cursor in the editor, on the same line.
local function review_goto_file()
  local view = require("diffview.lib").get_current_view()
  local file = view and view.infer_cur_file and view:infer_cur_file()
  local path = file and file.absolute_path
  if not (path and vim.uv.fs_stat(path)) then
    return
  end

  local cursor
  if view.cur_entry == file and view.cur_layout then
    local win = view.cur_layout:get_main_win()
    if win and vim.api.nvim_win_is_valid(win.id) then
      cursor = vim.api.nvim_win_get_cursor(win.id)
    end
  end

  vim.cmd.DiffviewClose()
  if vim.bo.filetype == "NeogitStatus" then
    -- The review was opened from the source control panel; leave that too.
    require("neogit.buffers.status").instance():close()
  end
  require("config.util").focus_editor()
  vim.cmd.edit(vim.fn.fnameescape(path))
  if cursor then
    pcall(vim.api.nvim_win_set_cursor, 0, cursor)
  end
end

-- Source control panel: Enter shows the entry under the cursor side by side
-- (a changed file, a whole section, or a commit). gf goes to the file instead.
local function neogit_review_entry()
  local status = require("neogit.buffers.status").instance()
  local ui = status and status.buffer and status.buffer.ui
  if not ui then
    return
  end

  local section = ui:get_selection().section
  local section_name = section and section.name
  local item = ui:get_yankable_under_cursor()
  local diffview = require("neogit.integrations.diffview")

  if section_name == "untracked" then
    vim.cmd.normal("gf") -- a new file has nothing to compare against
    return
  end
  require("config.util").close_reviews()
  if section_name then
    diffview.open(section_name, item, { only = true })
  elseif item then
    diffview.open("range", item .. "..HEAD")
  end
end

return {
  -- Gutter markers and per-change (hunk) actions
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame_opts = { delay = 400 },
      on_attach = function(buf)
        local gs = require("gitsigns")
        local function map(mode, keys, fn, desc)
          vim.keymap.set(mode, keys, fn, { buffer = buf, desc = desc })
        end
        local function selection()
          return { vim.fn.line("."), vim.fn.line("v") }
        end

        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next change")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Previous change")

        map("n", "<leader>gp", gs.preview_hunk_inline, "Peek change")
        map("n", "<leader>gs", gs.stage_hunk, "Stage / unstage change")
        map("x", "<leader>gs", function()
          gs.stage_hunk(selection())
        end, "Stage selected lines")
        map("n", "<leader>gr", gs.reset_hunk, "Discard change")
        map("x", "<leader>gr", function()
          gs.reset_hunk(selection())
        end, "Discard selected lines")
        map("n", "<leader>gS", gs.stage_buffer, "Stage file")
        map("n", "<leader>gR", gs.reset_buffer, "Discard all changes in file")
        map("n", "<leader>gb", function()
          gs.blame_line({ full = true })
        end, "Blame line")
        map("n", "<leader>gB", gs.toggle_current_line_blame, "Toggle inline blame")
        map({ "o", "x" }, "ih", gs.select_hunk, "Change (hunk)")
      end,
    },
  },

  -- Side-by-side review of all changes, with a changed-files panel
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    keys = {
      { "<leader>gd", toggle_review, desc = "Review changes (toggle)" },
      { "<leader>gD", review_branch, desc = "Review the whole branch" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "History of this file" },
      { "<leader>gH", from_editor("DiffviewFileHistory"), desc = "History of the branch" },
    },
    opts = function()
      local close = { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close review" } }
      local goto_file = { "n", "gf", review_goto_file, { desc = "Go to file (closes the review)" } }
      local plain = {}
      if not nerd then
        plain.icons = { folder_closed = "▸", folder_open = "▾" }
        plain.signs = { fold_closed = "▸", fold_open = "▾", done = "✓" }
      end
      return {
        enhanced_diff_hl = true,
        use_icons = nerd,
        icons = plain.icons,
        signs = plain.signs,
        file_panel = {
          listing_style = "tree",
          win_config = { position = "left", width = 36 },
        },
        keymaps = {
          view = { goto_file },
          file_panel = {
            close,
            goto_file,
            { "n", "cc", "<cmd>Neogit commit<cr>", { desc = "Commit staged changes" } },
          },
          file_history_panel = { close, goto_file },
        },
      }
    end,
  },

  -- Source control panel: stage, commit, push, pull, branches
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    keys = {
      { "<leader>gg", from_editor("Neogit"), desc = "Source control" },
      { "<leader>gc", from_editor("Neogit commit"), desc = "Commit" },
      { "<leader>gP", from_editor("Neogit push"), desc = "Push" },
      { "<leader>gF", from_editor("Neogit pull"), desc = "Pull" },
    },
    opts = {
      kind = "tab",
      graph_style = "unicode",
      disable_insert_on_commit = true, -- commit message box starts in normal mode, like any buffer
      integrations = { diffview = true, telescope = true },
      mappings = { status = { ["gf"] = "GoToFile" } },
    },
    config = function(_, opts)
      require("neogit").setup(opts)

      -- Neogit has no "diff on Enter" setting, so map it on its status buffer.
      local function attach(buf)
        vim.keymap.set("n", "<cr>", neogit_review_entry, { buffer = buf, nowait = true, desc = "Show change side by side" })
      end
      local group = vim.api.nvim_create_augroup("user_neogit_review_entry", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "NeogitStatus",
        callback = function(event)
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(event.buf) then
              attach(event.buf)
            end
          end)
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "NeogitStatusRefreshed",
        callback = function()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buf].filetype == "NeogitStatus" then
              attach(buf)
            end
          end
        end,
      })
    end,
  },
}
