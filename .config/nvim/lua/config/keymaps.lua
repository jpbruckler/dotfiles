vim.keymap.set("n", "<C-T>", ":Pick files<CR>")
vim.keymap.set("n", "<C-P>", ":Pick grep_live<CR>")
-- vim.keymap.set("n", "-", ":lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>")
vim.keymap.set("n", "<BS>", ":lua MiniTrailspace.trim()<CR>")

local minifiles_toggle = function(...)
  if not MiniFiles.close() then MiniFiles.open(...) end
end
vim.keymap.set("n", "-", minifiles_toggle, { desc = 'Toggle MiniFiles' })


-- Telescope
vim.keymap.set("n", "<leader>fh", require('telescope.builtin').help_tags, { desc = '[F]ind [H]elp tags' })
vim.keymap.set("n", "<leader>ff", require('telescope.builtin').find_files, { desc = '[F]ind [F]iles' })
vim.keymap.set("n", "<leader>en", function()
  require('telescope.builtin').find_files {
    cwd = vim.fn.stdpath("config")
  }
end)
vim.keymap.set("n", "<leader>ep", function()
  require('telescope.builtin').find_files {
    cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
  }
end)


-- Neotree
vim.keymap.set("n", '<C-b>', ':Neotree toggle<CR>', { desc = 'Toggles Neotree' })
