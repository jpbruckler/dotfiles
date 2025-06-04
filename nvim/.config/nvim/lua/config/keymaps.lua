local map = vim.keymap.set

-- Leader plus yank to send to system clipboard
map("n", "<leader>y", '"+y')
map("n", "<leader>p", '"+p')

-- Clear highlights on search when pressing <esc>
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Split keymaps
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

map("n", "-", "<cmd>Oil --float<CR>", { desc = "Open Parent Directory in Oil" })
map("n", "gl", function()
  vim.diagnostic.open_float()
end, { desc = "Open Diagnostics in Float" })

map("n", "<leader>cf", function()
  require("conform").format({
    lsp_format = "fallback",
  })
end, { desc = "Format current file" })

map("n", "<BS>", "<cmd>lua MiniTrailspace.trim()<CR>")

-- LuaSnip
local ls = require("luasnip")

-- Jump forward or expand
map({ "i", "s" }, "<Tab>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  else
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n")
  end
end, { silent = true, desc = "LuaSnip: expand or jump" })

-- Jump backward
map({ "i", "s" }, "<S-Tab>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  else
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, true, true), "n")
  end
end, { silent = true, desc = "LuaSnip: jump backward" })
