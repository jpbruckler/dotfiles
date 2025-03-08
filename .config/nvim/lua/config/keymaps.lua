local opts = { noremap = true, silent = true }
function customMerge(t1, t2)
    local result = {}
    for k, v in pairs(t1) do
        result[k] = v
    end
    for k, v in pairs(t2) do
        if result[k] then
            result[k] = { result[k], v } -- Handling duplicates as a list
        else
            result[k] = v
        end
    end
    return result
end

-- Save file
vim.keymap.set("n", "<C-s>", "<cmd>w<CR>", { desc = "Save with CTRL + S" })

-- save file without auto-formatting
vim.keymap.set("n", "<leader>sn", "<cmd>noautocmd w <CR>", customMerge({ des = "Save w/o autoformat"}, opts))

-- quit file
vim.keymap.set("n", "<C-q>", "<cmd> q <CR>", customMerge({ desc = "Quit"}, opts))

-- delete single character without copying into register
vim.keymap.set("n", "x", '"_x', customMerge({desc = 'Single character delete without yank'}, opts))


-- lua execution
-- keymaps to help with managing nvim config
vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear highlights when pressing <esc> in normal mode." })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix" })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })



-- Navigation keybinds
-- CTRL + hjkl to switch windows
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Buffer
vim.keymap.set("n", "<Tab>", ":bnext<CR>", customMerge({ desc = "Next Buffer" }, opts))
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", customMerge({ desc = "Previous Buffer" }, opts))
vim.keymap.set("n", "<leader>bx", ":bdelete!<CR>", customMerge({ desc = "[B]uffer Close !" }, opts))
vim.keymap.set("n", "<leader>bn", "<cmd> enew <CR>", customMerge({ desc = "[B]uffer [N]ew" }, opts)) -- new buffer

-- Navigate quickfix list with Alt + j/k
vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>")

-- Vertical scroll and center
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- Find and center
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)

-- Resize with arrows
vim.keymap.set("n", "<M-Up>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<M-Down>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<M-Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<M-Right>", ":vertical resize +2<CR>", opts)


-- Noice
vim.api.nvim_set_keymap("n", "<leader>nn", ":Noice dismiss<CR>", { noremap = true })
