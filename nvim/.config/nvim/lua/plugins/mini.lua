local function starter_header()
  local logo = {
    "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
    "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
    "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
    "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
    "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
    "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
  }

  local datetime = os.date(" %A, %B %d %Y  •  %I:%M %p ")
  local width = 50 -- total width inside the box

  -- Pad datetime to be centered
  local pad = math.floor((width - #datetime) / 2)
  local centered = string.rep(" ", pad) .. datetime

  local box_top = "╭────────────────────────────────────────────────╮"
  local box_middle = string.format("│%s│", centered .. string.rep(" ", width - #centered))
  local box_bottom = "╰────────────────────────────────────────────────╯"

  table.insert(logo, box_top)
  table.insert(logo, box_middle)
  table.insert(logo, box_bottom)

  return table.concat(logo, "\n")
end

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
      comment = true,
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
      starter = {
        evaluate_single = true,
        header = starter_header(),
        items = {
          -- File access
          { action = "lua require('fzf-lua').files()", name = "  Find file", section = "Files" },
          { action = "lua require('fzf-lua').oldfiles()", name = "  Recent files", section = "Files" },
          { action = "lua require('fzf-lua').live_grep()", name = "󰱽  Grep text", section = "Files" },

          -- Projects / sessions (you can wire this to zoxide or persisted)
          { action = "lua require('fzf-lua').dirs()", name = "󰈢  Projects", section = "Workspace" },
          -- Replace this with your session manager if you use one
          { action = "lua vim.notify('Session loading not configured')", name = "  Restore Session", section = "Workspace" },

          -- Notes / writing (Obsidian)
          { action = "ObsidianQuickSwitch", name = "  Open Obsidian Note", section = "Notes" },
          { action = "ObsidianNew", name = "  New Note", section = "Notes" },

          -- Terminal / Dev tools
          { action = "ToggleTerm direction=horizontal", name = "  Open Terminal", section = "Tools" },
          { action = "Lazy", name = "󰒲  Plugin Manager", section = "Tools" },

          -- Config
          { action = "e $MYVIMRC", name = "  Edit config", section = "Config" },
          { action = "source $MYVIMRC", name = "󰛶  Reload config", section = "Config" },
        },
        footer = function()
          local stats = require("lazy").stats()
          local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
          return "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
        end,
        content_hooks = {
          require("mini.starter").gen_hook.adding_bullet("» "),
          require("mini.starter").gen_hook.aligning("center", "center"),
        },
      },
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
