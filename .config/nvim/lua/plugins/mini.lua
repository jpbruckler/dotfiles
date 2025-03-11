return {
  'echasnovski/mini.nvim',
  version = false,
  config = function()
    local mini_specs = {
      'basics',
      'extra',
      'icons',
      'notify',
      'pick',
      'statusline',
      'trailspace',
    }
    for _, spec in pairs(mini_specs) do
      require('mini.' .. spec).setup()
    end

    require('mini.statusline').setup({
      use_icons = true,
    })

    require('mini.basics').setup({
      options = {
        extra_ui = true,
      },
      mappings = {
        windows = true,
        move_with_alt = true,
      },
    })

    --[[ minifiles
    local minifiles_toggle = function(...)
      if not MiniFiles.close() then
        MiniFiles.open(...)
      end
    end
    require('mini.files').setup({
      vim.keymap.set('n', '-', minifiles_toggle, { desc = "Toggle Minifiles" })
    })]]

    -- trim with backspace
    vim.keymap.set("n", "<BS>", ":lua MiniTrailspace.trim()<CR>")

    local starter = require('mini.starter')
    starter.setup({
      header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
        ]],
      footer = os.date(),
      query_updaters = 'abcdefghijklmnopqrstuvwxyz0123456789_.',
      items = {
        starter.sections.pick(),
        starter.sections.builtin_actions(),
      },
      content_hooks = {
        starter.gen_hook.adding_bullet("» "),
        function(content)
          -- Coords
          local header_coords = starter.content_coords(content, "header")
          local section_coords = starter.content_coords(content, "section")
          local item_coords = starter.content_coords(content, "item")
          local footer_coords = starter.content_coords(content, "footer")

          -- Lines
          local header_width = math.max(unpack(vim.tbl_map(function(c)
            local line = content[c.line][c.unit].string
            return vim.fn.strdisplaywidth(line)
          end, header_coords)))
          local section_width = math.max(unpack(vim.tbl_map(function(c)
            local line = content[c.line][c.unit].string
            return vim.fn.strdisplaywidth(line)
          end, section_coords)))
          local item_width = math.max(unpack(vim.tbl_map(function(c)
            local line = content[c.line][c.unit].string
            return vim.fn.strdisplaywidth(line)
          end, item_coords)))
          local footer_width = math.max(unpack(vim.tbl_map(function(c)
            local line = content[c.line][c.unit].string
            return vim.fn.strdisplaywidth(line)
          end, footer_coords)))
          local max_width = math.max(header_width, section_width, item_width, footer_width)

          for _, line in ipairs(content) do
            if not (#line == 0 or (#line == 1 and line[1].string == "")) then
              local line_str = ""
              local line_types = {}
              for _, unit in ipairs(line) do
                line_str = line_str .. unit.string
                table.insert(line_types, unit.type)
              end
              local line_width = 0
              for _, type in ipairs(line_types) do
                if type == "item" or type == "section" then
                  line_width = math.max(item_width, section_width)
                elseif type == "header" then
                  line_width = header_width
                elseif type == "footer" then
                  line_width = footer_width
                end
              end
              local left_pad = string.rep(" ", (max_width - line_width) * 0.5)

              table.insert(line, 1, { string = left_pad, type = "empty" })
            end
          end
          return content
        end,
        starter.gen_hook.aligning("center", "center"),
      },
    })
  end
}
