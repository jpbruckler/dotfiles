return {
    ts_ls = {},
    ruff = {},
    pylsp = {
        settings = {
            pylsp = {
                plugins = {
                    pyflakes = { enabled = false },
                    pycodestyle = { enabled = false },
                    autopep8 = { enabled = false },
                    yapf = { enabled = false },
                    mccabe = { enabled = false },
                    pylsp_mypy = { enabled = false },
                    pylsp_black = { enabled = false },
                    pylsp_isort = { enabled = false },
                },
            },
        },
    },
    html = { filetypes = { "html", "twig", "hbs" } },
    cssls = {},
    tailwindcss = {},
    dockerls = {},
    sqlls = {},
    terraformls = {},
    jsonls = {},
    yamlls = {},
    lua_ls = {
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim" },
                },
                format = {
                    enable = true,
                },
            },
        },
    },
    powershell_es = {
        filetypes = { "ps1", "psm1", "psd1" },
        bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
        settings = {
            powershell = {
                codeFormatting = {
                    -- Available settings, their defualt values, and descriptions can be found here:
                    -- nvim-data/mason/packages/powershell-editor-services/mason-schemas/lsp.json
                    preset = "Custom",                                      -- One of Custom, Allman, OTBS, Stroustrup
                    addWhitespaceAroundPipe = true,                         -- Defaults to true
                    avoidSemicolonsAsLineTerminators = true,                -- Defaults to false
                    trimWhitespaceAroundPipe = false,                       -- Defaults to false
                    openBraceOnSameLine = true,                             -- Defaults to true
                    ignoreOneLineBlock = true,                              -- Defaults to true
                    newLineAfterOpenBrace = true,                           -- Defaults to true
                    alignPropertyValuePairs = true,                         -- Defaults to true
                    newLineAfterCloseBrace = true,                          -- Defaults to true
                    useConstantStrings = true,                              -- Defaults to true
                    pipelineIndentationStyle = "IncreaseIndentationForFirstPipeline", -- Defaults to NoIndentation
                    useCorrectCasing = true,                                -- Defaults to false
                    whitespaceBeforeOpenBrace = true,                       -- Defaults to true
                    whitespaceBeforeOpenParen = true,                       -- Defaults to true
                    whitespaceAfterSeparator = true,                        -- Defaults to true
                    whitespaceInsideBrace = true,                           -- Defaults to true
                    whitespaceBetweenParameters = true,                     -- Defaults to false
                    whitespaceAroundOperator = true,                        -- Defaults to true
                    autoCorrectAliases = true,                              -- Defaults to false
                },
            },
        },
        init_options = {
            enableProfileLoading = false,
        },
    },
}
