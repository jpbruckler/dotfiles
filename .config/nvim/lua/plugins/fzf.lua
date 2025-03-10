return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  -- dependencies = { "nvim-tree/nvim-web-devicons" },
  -- or if using mini.icons/mini.nvim
  dependencies = { "echasnovski/mini.icons" },
  opts = {},
  keys = {
    { "<leader>ft", "<cmd>FzfLua awesome_colorschemes<CR>", desc = "[F]ind [T]heme" },

    { "<leader>sc", "<cmd>FzfLua files cwd=" .. vim.fn.stdpath("config") .. "<CR>", desc = "[S]earch Neovim [C]onfig" },
    { "<leader>sd", "<cmd>FzfLua diagnostics_document<CR>", desc = "[S]earch [D]iagnostics" },
    { "<leader>sf", "<cmd>FzfLua files<CR>", desc = "[S]earch [F]iles"},
    { "<leader>sh", "<cmd>FzfLua helptags<CR>", desc = "[S]earch [H]elp" },
    { "<leader>sk", "<cmd>FzfLua keymaps<CR>", desc = "[S]earch [K]eymaps" },
    { "<leader>sr", "<cmd>FzfLua oldfiles<CR>", desc = "[S]earch [R]ecent files" },
  }
}
