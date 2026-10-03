local opt = vim.opt

-- No plugin here uses the legacy remote-plugin hosts
for _, provider in ipairs({ "node", "perl", "python3", "ruby" }) do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end

-- Editor chrome
opt.number = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.showmode = false -- the status line already shows the mode
opt.laststatus = 3 -- one status line for the whole window, like VS Code
opt.wrap = false
opt.scrolloff = 6
opt.sidescrolloff = 8
opt.fillchars = { diff = "╱", eob = " " }

-- Mouse and clipboard
opt.mouse = "a"
-- Scheduled because probing the system clipboard slows startup.
vim.schedule(function()
  opt.clipboard = "unnamedplus"
end)

-- Splits open where VS Code opens them
opt.splitright = true
opt.splitbelow = true

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

-- Files
opt.undofile = true
opt.confirm = true -- ask to save instead of failing on unsaved changes
opt.updatetime = 250
opt.timeoutlen = 400

-- Easier to read diffs
opt.diffopt:append({ "algorithm:histogram", "indent-heuristic", "linematch:60" })
