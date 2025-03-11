return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      { "saghen/blink.cmp" },
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      }
    },
    config = function()
      local mason = require("mason")
      local masonlsp = require("mason-lspconfig")
      local lspconfig = require("lspconfig")
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      mason.setup()
      masonlsp.setup({
        ensure_installed = {
          "lua_ls",
          "powershell_es",
          "rust_analyzer",
        },
        automatic_installation = true,
      })

      -- Server configs
      lspconfig.lua_ls.setup({ capabilities = capabilities })

      lspconfig.powershell_es.setup({
        filetypes = { "ps1", "psm1", "psd1" },
        bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
        capabilities = capabilities,
        settings = {
          powershell = {
            codeFormatting = {
              -- Available settings, their defualt values, and descriptions can be found here:
              -- nvim-data/mason/packages/powershell-editor-services/mason-schemas/lsp.json
              -- Setting `preset` to anything other than Custom will override all other format
              -- settings.
              preset = "Custom",                                                -- One of Custom, Allman, OTBS, Stroustrup
              addWhitespaceAroundPipe = true,                                   -- Defaults to true
              avoidSemicolonsAsLineTerminators = true,                          -- Defaults to false
              trimWhitespaceAroundPipe = false,                                 -- Defaults to false
              openBraceOnSameLine = true,                                       -- Defaults to true
              ignoreOneLineBlock = true,                                        -- Defaults to true
              newLineAfterOpenBrace = true,                                     -- Defaults to true
              alignPropertyValuePairs = true,                                   -- Defaults to true
              newLineAfterCloseBrace = true,                                    -- Defaults to true
              useConstantStrings = true,                                        -- Defaults to true
              pipelineIndentationStyle = "IncreaseIndentationForFirstPipeline", -- Defaults to NoIndentation
              useCorrectCasing = true,                                          -- Defaults to false
              whitespaceBeforeOpenBrace = true,                                 -- Defaults to true
              whitespaceBeforeOpenParen = true,                                 -- Defaults to true
              whitespaceAfterSeparator = true,                                  -- Defaults to true
              whitespaceInsideBrace = true,                                     -- Defaults to true
              whitespaceBetweenParameters = true,                               -- Defaults to false
              whitespaceAroundOperator = true,                                  -- Defaults to true
              autoCorrectAliases = true,                                        -- Defaults to false
            },
          },
        },
        init_options = {
          enableProfileLoading = false,
        },
      })

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          if client.supports_method('textDocument/formatting') then
            -- format on save
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
              end
            })
          end
        end
      })
    end
  }
}
