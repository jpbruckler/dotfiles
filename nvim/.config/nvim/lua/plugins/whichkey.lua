return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  notify = true,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  plugins = {
    marks = true,     -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    spelling = {
      enabled = true,   -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    presets = {
      operators = true,    -- adds help for operators like d, y, ...
      motions = true,      -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true,      -- default bindings on <c-w>
      nav = true,          -- misc bindings to work with windows
      z = true,            -- bindings for folds, spelling and others prefixed with z
      g = true,            -- bindings for prefixed with g
    },
  },
  preset = "modern",
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
  configure = function()
    local wk = require("which-key")
    wk.add({
      { "<leader>c",  group = "[C]ode",                mode = { "n", "x" } },
      { "<leader>d",  group = "[D]ocument" },
      { "<leader>r",  group = "[R]ename" },
      { "<leader>s",  group = "[S]earch" },
      { "<leader>w",  group = "[W]orkspace" },
      { "<leader>t",  group = "[T]oggle" },
      { "<leader>h",  group = "Git [H]unk",            mode = { "n", "v" } },

      { "<leader>f",  group = "file" }, -- group
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File", mode = "n" },
      {
        "<leader>fb",
        function()
          print("hello")
        end,
        desc = "Foobar",
      },
      { "<leader>fn", desc = "New File" },
      { "<leader>f1", hidden = true },                     -- hide this keymap
      { "<leader>w",  proxy = "<c-w>",  group = "windows" }, -- proxy to window mappings
      {
        "<leader>b",
        group = "buffers",
        expand = function()
          return require("which-key.extras").expand.buf()
        end,
      },
      {
        -- Nested mappings are allowed and can be added in any order
        -- Most attributes can be inherited or overridden on any level
        -- There's no limit to the depth of nesting
        mode = { "n", "v" },                          -- NORMAL and VISUAL mode
        { "<leader>q", "<cmd>q<cr>", desc = "Quit" }, -- no need to specify mode since it's inherited
        { "<leader>w", "<cmd>w<cr>", desc = "Write" },
      },
    })
  end,
}
