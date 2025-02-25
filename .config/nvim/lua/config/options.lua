vim.g.have_nerd_font = true -- for other settings later

-- :help vim.opt
-- :help option-list

vim.wo.number        = true                    -- turn line numbers on
vim.o.relativenumber = true                    -- turn on relaative line numbers
vim.o.clipboard      = 'unnamedplus'           -- sync os <--> vim clipboard
vim.o.wrap           = false                   -- do not word wrap
vim.o.linebreak      = true                    -- with wrap, don't split words
vim.o.mouse          = 'a'                     -- enable mouse mode
vim.o.autoindent     = true                    -- copy indent from current line
vim.o.ignorecase     = true                    -- case-insensitive searching UNLESS \C or capital in search
vim.o.smartcase      = true                    -- enable smart case
vim.o.shiftwidth     = 4                       -- number of spaces inserted for an indent (default 8)
vim.o.tabstop        = 4                       -- insert N spaces for a tab
vim.o.softtabstop    = 4                       -- number of spaces a tab counts for
vim.o.expandtab      = true                    -- uses spaces instead of tabs
vim.o.scrolloff      = 4                       -- min # of screen lines to keep above/below cursor
vim.o.sidescrolloff  = 8                       -- min # of screen columns on either side of cursor if wrap is `false`
vim.o.showmode       = false                   -- don't show the mode since it's already in the status line
vim.o.breakindent    = true                    -- Enable break indent
vim.o.undofile       = true                    -- Save undo history
vim.o.ignorecase     = true                    -- case inSenSItIve searching unless \C or
vim.o.smartcase      = true                    -- one or more capital letters in search term
vim.o.signcolumn     = 'yes'                   -- Keep signcolumn on by default
vim.o.updatetime     = 250                     -- Decrease update time
vim.o.timeoutlen     = 300                     -- Decrease mapped sequence wait time
vim.o.splitright     = true                    -- force vertifal splits to the right of the current window
vim.o.splitbelow     = true                    -- force horizontal splits below current window
vim.o.cursorline     = false                   -- do not highlight
vim.o.numberwidth    = 2
vim.o.list           = true                    -- sets how neovim will display certain whitespace
vim.o.updatetime     = 250                     -- Decrease update time (default: 4000)
vim.o.timeoutlen     = 300                     -- Time to wait for a mapped sequence to complete (in milliseconds) (default: 1000)
vim.o.backup         = false                   -- Creates a backup file (default: false)
vim.o.writebackup    = false                   -- If a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited (default: true)
vim.o.undofile       = true                    -- Save undo history (default: false)
vim.o.completeopt    =
'menuone,noselect'                             -- Set completeopt to have a better completion experience (default: 'menu,preview')
vim.opt.shortmess:append 'c'                   -- Don't give |ins-completion-menu| messages (default: does not include 'c')
vim.opt.iskeyword:append '-'                   -- Hyphenated words recognized by searches (default: does not include '-')
vim.opt.formatoptions:remove { 'c', 'r', 'o' } -- Don't insert the current comment leader automatically for auto-wrapping comments using 'textwidth', hitting <Enter> in insert mode, or hitting 'o' or 'O' in normal mode. (default: 'croql')

vim.opt.listchars = {                          -- see `:help list` and `:help 'listchars'`
    tab = '» ',
    trail = '·',
    nbsp = '␣'
}

-- In Windows, set the terminal shell to PowerShell
if package.config:sub(1, 1) == '\\' then
    local homePath     = vim.env.HOME
    vim.o.shell        = "pwsh"
    vim.o.shellcmdflag = table.concat({
        '-NoLogo',
        '-NonInteractive',
        '-ConfigurationFile "' .. homePath .. '/.config/nvim/nvim.pssc"',
        '-ExecutionPolicy RemoteSigned',
        '-Command'
    }, ' ')
    vim.o.shellquote   = ''
    vim.o.shellxquote  = ''
    vim.o.shellredir   = '2>&1 | Out-File -Encoding UTF8 %s'
    vim.o.shellpipe    = '2>&1 | Out-File -Encoding UTF8 %s'
end
