return {
  -- Highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  main = "nvim-treesitter.configs", -- Sets main module to use for opts
  -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
  opts = {
    ensure_installed = {
      "bash",
      "c",
      "diff",
      "html",
      "kusto",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "powershell",
      "query",
      "vim",
      "vimdoc",
    },
    -- Autoinstall languages that are not installed
    auto_install = true,
    highlight = {
      enable = true,
      use_languagetree = true,
      -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
      --  If you are experiencing weird indenting issues, add the language to
      --  the list of additional_vim_regex_highlighting and disabled languages for indent.
      additional_vim_regex_highlighting = { "ruby" },
    },
    indent = { enable = true },
    autotag = {
      enable = true,
      enable_rename = true,
      enable_close = true,
      enable_close_on_slash = true,
      filetypes = { "html", "xml" },
    },
  },
  config = function()
    local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    treesitter_parser_config.powershell = {
      install_info = {
        url = "~/.config/nvim/tsparsers/tree-sitter-powershell",
        files = { "src/parser.c", "src/scanner.c" },
        branch = "main",
        generate_requires_npm = false,
        requires_generate_from_grammar = false,
      },
      filetype = { "ps1", "psd1", "psm1" },
    }
  end,
}
