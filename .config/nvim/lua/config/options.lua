-- Some keyboard mappings as I don't want to break my fingers, while typing on a "german" keyboard ;)
vim.opt.langmap = "+]ü["
-- Plain langmap remapping does not seem to do the trick :(
vim.keymap.set("n", "ü", "[", { remap = true })

vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.shiftwidth = 4   -- Amount to indent with << and >>
vim.opt.tabstop = 4      -- How many spaces are shown per Tab
vim.opt.softtabstop = 4  -- How many spaces are applied when pressing Tab

vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.autoindent = true -- Keep identation from previous line

-- Enable break indent
vim.opt.breakindent = true

-- Always show relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Show line under cursor
vim.opt.cursorline = true

-- Store undos between sessions
vim.opt.undofile = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 5
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = "menu,menuone,noinsert,noselect"
vim.opt.confirm = true
vim.opt.diffopt = "internal,filler,closeoff,foldcolumn:1,hiddenoff,algorithm:histogram,linematch:120,indent-heuristic"

-- In Windows, set the terminal shell to PowerShell
-- In powershell profile include the following:
--
--  if ($env:VIMRUNTIME) {
--    $PSStyle.OutputRendering = 'PlainText'
--  }
--
-- Which will set the OutputRendering to PlainText
-- when PowerShell is opened from neovim ($env:VIMRUNTIME
-- does not normally exist as an environment variable)
local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
if is_windows then
  vim.o.shell = "pwsh"
  vim.o.shellcmdflag = table.concat({
    "-NoLogo",
    "-NonInteractive",
    "-ExecutionPolicy RemoteSigned",
    "-Command",
  }, " ")
  vim.o.shellquote = ""
  vim.o.shellxquote = ""
  vim.o.shellredir = "2>&1 | Out-File -Encoding UTF8 %s"
  vim.o.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s"
end
