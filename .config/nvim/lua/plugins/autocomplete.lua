return {
  "saghen/blink.cmp",
  -- optional: provides snippets for the snippet source
  dependencies = "rafamadriz/friendly-snippets",
  version = "*",
  ---@type blink.cmp.Config
  opts = {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept, C-n/C-p for up/down)
    -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys for up/down)
    -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-e: Hide menu
    -- C-k: Toggle signature help
    --
    -- See the full "keymap" documentation for information on defining your own keymap.
    keymap = { preset = "default" },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
    },

    sources = {
      default = function(ctx)
        local success, node = pcall(vim.treesitter.get_node)
        if vim.bo.filetype == "lua" then
          return { "lsp", "path" }
        elseif success and node and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
          return { "buffer" }
        else
          return { "lsp", "path", "snippets", "buffer" }
        end
      end,
      providers = {
        cmdline = {
          -- ignores cmdline completions when executing shell commands
          enabled = function()
            return vim.fn.getcmdtype() ~= ":" or not vim.fn.getcmdline():match("^[%%0-9,'<>%-]*!")
          end,
        },
      },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
  completion = {
    menu = {
      draw = {
        components = {
          kind_icon = {
            ellipsis = false,
            text = function(ctx)
              local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
              return kind_icon
            end,
            -- Optionally, you may also use the highlights from mini.icons
            highlight = function(ctx)
              local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
              return hl
            end,
          },
        },
      },
    },
  },
}
