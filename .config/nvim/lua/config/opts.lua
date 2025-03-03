---@diagnostic disable: undefined-global
-- Numbers
vim.wo.number = true
vim.o.relativenumber = true

-- Clipboard
vim.o.clipboard = 'unnamedplus'

-- Mouse (burn the heretic!)
vim.o.mouse = 'a'

-- Indents
vim.o.autoindent = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.expandtab = true

-- save undo history
vim.o.undofile = true

-- enable breakindent
vim.o.breakindent = true

-- keep signcolumn on
vim.wo.signcolumn = 'yes'

-- decrease update times
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- set completeopt for better experience
vim.o.completeopt = 'menuone,noselect'

-- enable terminal gui colors
vim.o.termguicolors = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Window splits
vim.o.splitright = true
vim.o.splitbelow = true

-- Cursor
vim.o.cursorline = true

-- In Windows, set the terminal shell to PowerShell
-- The nvim.pssc is a PowerShell session configuration file
-- that's used to set the variable $NvimShell. My PowerShell
-- profile keys off this value to set the output encoding to
-- plaintext when $NvimShell exists.
local is_windows = vim.loop.os_uname().system == 'Windows_NT'
if is_windows then
	local homePath = vim.env.HOME
	vim.o.shell = "pwsh"
	vim.o.shellcmdflag = table.concat({
		"-NoLogo",
		"-NonInteractive",
		'-ConfigurationFile "' .. homePath .. '/.config/nvim/nvim.pssc"',
		"-ExecutionPolicy RemoteSigned",
		"-Command",
	}, " ")
	vim.o.shellquote = ""
	vim.o.shellxquote = ""
	vim.o.shellredir = "2>&1 | Out-File -Encoding UTF8 %s"
	vim.o.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s"
end
