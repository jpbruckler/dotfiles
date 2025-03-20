return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ensure_installed = {
        "c",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "javascript",
        "json",
        "html",
        "markdown",
        "markdown_inline",
        "powershell",
      },
      auto_install = true,
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<Enter>", -- set to `false` to disable one of the mappings
          node_incremental = "<Enter>",
          scope_incremental = false,
          node_decremental = "<Backspace>",
        },
      },
    })

    local ts_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    ts_parser_config.powershell = {
      filetype = { "ps1", "psm1", "psd1" },
    }
  end,
}
