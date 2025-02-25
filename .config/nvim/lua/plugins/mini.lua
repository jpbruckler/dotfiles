return {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
        local mini_modules = {
            "ai",
            "basics",
            "bracketed",
            "comment",
            "completion",
            "files",
            "icons",
            -- "indentscope",
            "jump",
            -- "jump2d",
            "pairs",
            -- "pick",
            "splitjoin",
            "statusline",
            "surround",
            "tabline",
            "trailspace"
        }

        for _, module in ipairs(mini_modules) do
            require("mini." .. module).setup()
        end
        require('mini.indentscope').gen_animation.none()
        -- Better Around/Inside textobjects
        --
        -- Examples:
        --  - va)  - [V]isually select [A]round [)]paren
        --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
        --  - ci'  - [C]hange [I]nside [']quote
        require('mini.ai').setup { n_lines = 500 }

        -- Add/delete/replace surroundings (brackets, quotes, etc.)
        --
        -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
        -- - sd'   - [S]urround [D]elete [']quotes
        -- - sr)'  - [S]urround [R]eplace [)] [']
        require('mini.surround').setup()

        -- Simple and easy statusline.
        --  You could remove this setup call if you don't like it,
        --  and try some other statusline plugin
        local statusline = require 'mini.statusline'
        -- set use_icons to true if you have a Nerd Font
        statusline.setup { use_icons = vim.g.have_nerd_font }

        -- You can configure sections in the statusline by overriding their
        -- default behavior. For example, here we set the section for
        -- cursor location to LINE:COLUMN
        ---@diagnostic disable-next-line: duplicate-set-field
        statusline.section_location = function()
            return '%2l:%-2v'
        end
    end
}
