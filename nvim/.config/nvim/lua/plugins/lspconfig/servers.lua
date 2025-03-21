return {
  marksman = {},
  lua_ls = {},
  powershell_es = {
    filetypes = { "ps1", "psm1", "psd1" },
    bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
    on_attach = function(client, bufnr)
      vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    end,
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
        scriptAnalysis = {
          enable = true,
        },
        developer = {
          editorServicesLogLevel = "Information",
        },
      },
    },
    init_options = {
      enableProfileLoading = false,
    },
  },
}
