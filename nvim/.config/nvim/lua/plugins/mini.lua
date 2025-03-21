return {
  'echasnovski/mini.nvim',
  version = false,
  config = function()
    local mini_specs = {
      ai = {
        custom_textobjects = {
          -- some extra motions for PowerShell
          -- Scriptblock or any `{}` block
          B = {
            a = { "%b{}", "^.().*().$" },
            i = { "%b{}", "^.{().*()}$" },
          },

          -- Hashtable: @{ key = value }
          h = {
            a = { "@%b{}", "^.().*().$" },
            i = { "@%b{}", "^.@{().*()}$" },
          },

          -- Array: @()
          a = {
            a = { "@%b()", "^.().*().$" },
            i = { "@%b()", "^.@%(().*())$" },
          },

          -- String in quotes
          q = {
            a = { [["[^"]*"]], '^.().*().$' },
            i = { [["[^"]*"]], '^."().*"()$' },
          },
          f = { -- Function names
            a = { "%f[%w]function%s+[%w%-_]+", "()function%s+()[%w%-_]+" },
            i = { "%f[%w]function%s+[%w%-_]+", "function%s+()([%w%-_]+)()" },
          },

          p = { -- Pipelines
            a = { [[[%w\-]+\s+|[%w\-]+\s*\{.-\}]], '()%f[%w].-()%s*|' },
            i = { [[[%w\-]+\s+|[%w\-]+\s*\{.-\}]], [[|%s*()([%w\-]+.-)()]] },
          },

          s = { -- Here-strings
            a = { [[@".-."@]], '()@".-."@()' },
            i = { [[@".-."@]], '@()"().-"()@' },
          },
        }
      },
      basics = {
        options = {
          extra_ui = true
        },
        mappings = {
          windows = true,
          move_with_alt = true,
        },
      },
      extra = true,
      hipatterns = true,
      icons = true,
      indentscope = true,
      notify = true,
      pick = true,
      statusline = {
        use_icons = true,
        set_vim_settings = true,
      },
      trailspace = true,
      move = true,
      surround = {
        mappings = {
          add = 'gsa',
          delete = 'gsd',
          replace = 'gsr',
        },
      },
    }

    for spec, opts in pairs(mini_specs) do
      if opts == true then
        opts = {}
      end
      require('mini.' .. spec).setup(opts)
    end
  end,
}
