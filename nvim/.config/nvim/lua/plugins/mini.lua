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

  local box_top =
  "╭────────────────────────────────────────────────╮"
  local box_middle = string.format("│%s│", centered .. string.rep(" ", width - #centered))
  local box_bottom =
  "╰────────────────────────────────────────────────╯"

  table.insert(logo, box_top)
  table.insert(logo, box_middle)
  table.insert(logo, box_bottom)

  return table.concat(logo, "\n")
end

return {
  "echasnovski/mini.nvim",
  version = false,
  config = function()
    local mini_specs = {
      ai = true,
      basics = {
        options = {
          extra_ui = true,
        },
        mappings = {
          windows = true,
          move_with_alt = true,
        },
      },
      comment = true,
      extra = true,
      git = true,
      hipatterns = {
        -- Highlight standalone 'FIX', 'FIXME', 'HACK', 'TODO', 'NOTE'
        fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
        fix = { pattern = "%f[%w]()FIX()%f[%W]", group = "MiniHipatternsFixme" },
        hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
        todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
        note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

        -- Highlight hex color strings (`#rrggbb`) using that color
        -- #992233, #229933, #223399
        hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),

        trailspace = {
          pattern = "%f[%s]%s*$",
          group = require("mini.hipatterns").compute_hex_color_group("#747070", "bg"),
        },
      },
      icons = true,
      indentscope = true,
      notify = true,
      sessions = true,
      statusline = {
        use_icons = true,
        set_vim_settings = true,
        content = {
          active = function()
            local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 1024 })
            local git = MiniStatusline.section_git({ trunc_width = 75 })
            local diff = MiniStatusline.section_diff({ trunc_width = 75 })
            local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
            local lsp = MiniStatusline.section_lsp({ trunc_width = 75 }) -- Shows number of attached lsp servers
            local filename = MiniStatusline.section_filename({ trunc_width = 100 })
            local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
            local location = MiniStatusline.section_location({ trunc_width = 75 })
            local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

            return MiniStatusline.combine_groups({
              { hl = mode_hl,                 strings = { mode } },
              { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
              "%<", -- Mark general truncate point
              { hl = "MiniStatuslineFilename",    strings = { filename } },
              "%=", -- End left alignment
              { hl = "MiniStatuslineModeReplace", strings = { search } },
              { hl = "MiniStatuslineFileinfo",    strings = { fileinfo } },
              { hl = mode_hl,                     strings = { location } },
              -- { hl = mode_hl, strings = { "%l:%c%V %P 0x%B" } }, -- remove '0x%B', use :ascii
            })
          end,

          inactive = function()
            local filename = MiniStatusline.section_filename({ trunc_width = 140 })
            return MiniStatusline.combine_groups({
              { hl = "MiniStatuslineDevinfo", strings = { filename } },
            })
          end,
        },
      },
      trailspace = true,
      move = true,
      starter = {
        evaluate_single = true,
        header = starter_header(),
        items = {
          -- File access
          { action = "enew", name = "E - New scratch file", section = "Files" },
          { action = "lua require('fzf-lua').files()", name = "F -   Find file", section = "Files" },
          { action = "lua require('fzf-lua').oldfiles()", name = "H -   File History", section = "Files" },
          {
            action = "lua require('fzf-lua').live_grep()",
            name = "L - 󰱽  Live Grep current Directory",
            section = "Files",
          },
          { action = "Oil", name = "O - Open Oil", section = "Files" },

          -- Terminal / Dev tools
          { action = "ToggleTerm direction=horizontal", name = "T -   Open Terminal", section = "Tools" },
          { action = "Lazy", name = "Z - 󰒲  Lazy Plugin Manager", section = "Tools" },
          { action = "Mason", name = "M - 󰣪 Mason", section = "Tools" },
          { action = "LazyGit", name = "G - 󰊢 LazyGit", section = "Tools" },

          -- Config
          { action = "e $MYVIMRC", name = "C -   Edit config", section = "Config" },
          { action = "source $MYVIMRC", name = "R - 󰛶  Reload config", section = "Config" },

          -- Sessions
          require("mini.starter").sections.sessions(3, true),
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
          add = "gsa",
          delete = "gsd",
          replace = "gsr",
        },
      },
    }

    for spec, opts in pairs(mini_specs) do
      if opts == true then
        opts = {}
      end
      require("mini." .. spec).setup(opts)
    end
  end,
}
