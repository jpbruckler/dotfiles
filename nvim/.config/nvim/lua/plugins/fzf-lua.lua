return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  -- dependencies = { "nvim-tree/nvim-web-devicons" },
  -- or if using mini.icons/mini.nvim
  dependencies = { "echasnovski/mini.icons" },
  opts = {},
  keys = {
    {
      "<leader>ql",
      function()
        require("fzf-lua").quickfix()
      end,
      desc = "[Q]uickfix [L]ist",
    },
    {
      "<leader>qs",
      function()
        require("fzf-lua").quickfix_stack()
      end,
      desc = "[Q]uickfix [S]tack",
    },
    {
      "<leader>fb",
      function()
        require("fzf-lua").builtin()
      end,
      desc = "[F]zf [B]uiltins",
    },
    {
      "<leader>sb",
      function()
        require("fzf-lua").buffers()
      end,
      desc = "[S]earch existing [B]uffers",
    },
    {
      "<leader>sq",
      function()
        require("fzf-lua").grep_quickfix()
      end,
      desc = "[S]earch [Q]uickfix list",
    },
    {
      "<leader>sc",
      function()
        require("fzf-lua").command_history()
      end,
      desc = "[S]earch in [C]ommand history",
    },
    {
      "<leader>sd",
      function()
        require("fzf-lua").diagnostics_document()
      end,
      desc = "[S]earch [D]iagnostics",
    },
    {
      "<leader>sf",
      function()
        require("fzf-lua").files()
      end,
      desc = "[S]earch [F]iles in project directory",
    },
    {
      "<leader>sg",
      function()
        require("fzf-lua").live_grep()
      end,
      desc = "[S]earch by [G]repping in project directory",
    },
    {
      "<leader>sh",
      function()
        require("fzf-lua").helptags()
      end,
      desc = "[S]earch [H]elptags",
    },
    {
      "<leader>sk",
      function()
        require("fzf-lua").keymaps()
      end,
      desc = "[S]earch [K]eymaps",
    },
    {
      "<leader>sn",
      function()
        require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "[S]earch in [N]eovim configuration",
    },
    {
      "<leader>so",
      function()
        require("fzf-lua").oldfiles()
      end,
      desc = "[S]earch [O]ld Files",
    },
    {
      "<leader>sr",
      function()
        require("fzf-lua").resume()
      end,
      desc = "[S]earch [R]esume",
    },
    {
      "<leader>sw",
      function()
        require("fzf-lua").grep_cword()
      end,
      desc = "[S]earch current [W]ord",
    },
    {
      "<leader>sW",
      function()
        require("fzf-lua").grep_cWORD()
      end,
      desc = "[S]earch current [W]ORD",
    },

    {
      "<leader>/",
      function()
        require("fzf-lua").lgrep_curbuf()
      end,
      desc = "[/] Live grep the current buffer",
    },
  },
}
