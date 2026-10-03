local M = {}

-- Close a buffer without collapsing the window layout (like closing a tab in VS Code).
function M.close_buffer(buf)
  buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf

  if vim.bo[buf].modified then
    local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
    local choice = vim.fn.confirm(("Save changes to %s?"):format(name ~= "" and name or "Untitled"), "&Save\n&Don't save\n&Cancel")
    if choice == 1 then
      vim.api.nvim_buf_call(buf, vim.cmd.write)
    elseif choice ~= 2 then
      return
    end
  end

  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.api.nvim_win_call(win, function()
      if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= buf then
        return
      end
      local alt = vim.fn.bufnr("#")
      if alt ~= buf and vim.fn.buflisted(alt) == 1 then
        vim.api.nvim_win_set_buf(win, alt)
        return
      end
      local has_previous = pcall(vim.cmd, "bprevious")
      if has_previous and buf ~= vim.api.nvim_win_get_buf(win) then
        return
      end
      vim.api.nvim_win_set_buf(win, vim.api.nvim_create_buf(true, false))
    end)
  end

  if vim.api.nvim_buf_is_valid(buf) then
    pcall(vim.cmd, "bdelete! " .. buf)
  end
end

-- Move focus out of the sidebar into a normal editor window of this tab, if there is one.
-- Git views open in their own tab and later "go to file" in whichever window was
-- focused here, so this keeps files from being opened inside the sidebar.
function M.focus_editor()
  local function is_editor(win)
    return vim.api.nvim_win_get_config(win).relative == "" and vim.bo[vim.api.nvim_win_get_buf(win)].buftype == ""
  end
  if is_editor(0) then
    return true
  end
  local candidates = { vim.fn.win_getid(vim.fn.winnr("#")) }
  vim.list_extend(candidates, vim.api.nvim_tabpage_list_wins(0))
  for _, win in ipairs(candidates) do
    if win ~= 0 and vim.api.nvim_win_is_valid(win) and is_editor(win) then
      vim.api.nvim_set_current_win(win)
      return true
    end
  end
  return false
end

-- Close every open review tab, so there is never more than one.
function M.close_reviews()
  local lib = require("diffview.lib")
  for _, view in ipairs(vim.list_slice(lib.views)) do
    view:close()
    lib.dispose_view(view)
  end
end

-- Open the side-by-side review focused on one changed file.
function M.review_file(path)
  M.focus_editor()
  M.close_reviews()
  require("diffview").open({ "--selected-file=" .. path })
end

return M
