-- General shortcuts. Plugin shortcuts live next to each plugin in lua/plugins/.
local map = vim.keymap.set

-- Save
map({ "n", "i", "x", "s" }, "<C-s>", "<cmd>write<cr><esc>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>confirm qall<cr>", { desc = "Quit" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Move between editor groups
map("n", "<C-h>", "<C-w>h", { desc = "Focus left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Focus lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Focus upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Focus right window" })
map("n", "<leader>\\", "<cmd>vsplit<cr>", { desc = "Split editor right" })
map("n", "<leader>-", "<cmd>split<cr>", { desc = "Split editor down" })

-- Go back / forward through cursor history
map("n", "<A-Left>", "<C-o>", { desc = "Go back" })
map("n", "<A-Right>", "<C-i>", { desc = "Go forward" })

-- Move lines up and down
for _, keys in ipairs({ { "<A-j>", "<A-k>" }, { "<A-Down>", "<A-Up>" } }) do
  local down, up = keys[1], keys[2]
  map("n", down, "<cmd>move .+1<cr>==", { desc = "Move line down" })
  map("n", up, "<cmd>move .-2<cr>==", { desc = "Move line up" })
  map("i", down, "<esc><cmd>move .+1<cr>==gi", { desc = "Move line down" })
  map("i", up, "<esc><cmd>move .-2<cr>==gi", { desc = "Move line up" })
  map("x", down, ":move '>+1<cr>gv=gv", { desc = "Move selection down", silent = true })
  map("x", up, ":move '<-2<cr>gv=gv", { desc = "Move selection up", silent = true })
end

-- Toggle comment. Most terminals send Ctrl+/ as <C-_>.
for _, key in ipairs({ "<C-/>", "<C-_>" }) do
  map("n", key, "gcc", { remap = true, desc = "Toggle comment" })
  map("x", key, "gc", { remap = true, desc = "Toggle comment" })
  map("i", key, "<cmd>normal gcc<cr>", { desc = "Toggle comment" })
end

-- Keep the selection when indenting
map("x", "<", "<gv")
map("x", ">", ">gv")

-- Buffers behave as editor tabs
map("n", "<leader>bd", function()
  require("config.util").close_buffer()
end, { desc = "Close tab" })
