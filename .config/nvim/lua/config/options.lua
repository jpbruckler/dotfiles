local opt = vim.opt

vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

vim.g.mapleader = ' '                 -- <space>, both the final frontier and the leader key
vim.g.maplocalleader = ' '            -- see `:help mapleader`
vim.g.have_nerd_font = true

-- [[ set options ]]
-- see `:help vim.opt`
-- see `:help option-list`
-- make line numbers default
opt.number = true
-- vim.opt.relativenumber = true

opt.mouse = 'a'                       -- enable mouse mode (helps with resizing splits)
opt.showmode = false                  -- don't show the mode since it's already in the status line

-- sync clipboard OS <--> Neovim
-- see `:help clipboard`
-- Schedule this after `UiEnter` to minimize startup time impact
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

opt.breakindent = true                -- Enable break indent
opt.undofile = true                   -- Save undo history

opt.ignorecase = true                 -- case inSenSItIve searching unless \C or
opt.smartcase = true                  -- one or more capital letters in search term

opt.signcolumn = 'yes'                -- Keep signcolumn on by default

opt.updatetime = 250                  -- Decrease update time
opt.timeoutlen = 300                  -- Decrease mapped sequence wait time

opt.splitright = true                 -- configure how splits should be opened
opt.splitbelow = true

opt.list = true                       -- sets how neovim will display certain whitespace
opt.listchars = {                     -- see `:help list` and `:help 'listchars'`
  tab = '» ',
  trail = '·',
  nbsp = '␣'
}

opt.inccommand = 'split'              -- Preview substitutions live, as you type!
opt.cursorline = true                 -- show which line the cursor is on
opt.scrolloff = 10                    -- min # of lines to keep above and below the cursor


