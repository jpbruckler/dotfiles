return {
  "nvim-telescope/telescope.nvim",
  event = "VimEnter",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-tree/nvim-web-devicons",
    "nvim-telescope/telescope-ui-select.nvim",
    "jonarrien/telescope-cmdline.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
  },
  keys = {
    {
      "<leader>f",
      function()
        require("config.utils").telescope_git_or_file()
      end,
      desc = "Find Files (Root)",
    },
    {
      "<leader>sf",
      function()
        require("telescope.builtin").find_files()
      end,
      desc = "[S]earch [F]iles",
    },
    {
      "<leader>ss",
      function()
        require("telescope.builtin").builtin()
      end,
      desc = "[S]earch [S]elect Telescope",
    },
    {
      "<leader>sw",
      function()
        require("telescope.builtin").grep_string()
      end,
      desc = "[S]earch current [W]ord",
    },
    {
      "<leader>sg",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "[S]earch by [G]rep",
    },
    {
      "<leader>sd",
      function()
        require("telescope.builtin").diagnostics()
      end,
      desc = "[S]earch [D]iagnostics",
    },
    {
      "<leader>sr",
      function()
        require("telescope.builtin").resume()
      end,
      desc = "[S]earch [R]esume",
    },
    {
      "<leader>s.",
      function()
        require("telescope.builtin").oldfiles()
      end,
      desc = '[S]earch Recent Files ("." for repeat)',
    },
    {
      "<leader><leader>",
      function()
        require("telescope.builtin").buffers()
      end,
      desc = "[ ] Find existing buffers",
    },
    {
      "<leader>gg",
      function()
        require("telescope.builtin").git_files()
      end,
      desc = "[G]rep [G]it",
    },
    {
      "<leader>sh",
      function()
        require("telescope.builtin").help_tags()
      end,
      desc = "[S]earch [H]elp",
    },
    {
      "<leader>sk",
      function()
        require("telescope.builtin").keymaps()
      end,
      desc = "[S]earch [K]eymaps",
    },
    {
      "<leader>sR",
      function()
        require("telescope.builtin").registers()
      end,
      desc = "Registers",
    },
    {
      "<leader>sC",
      function()
        require("telescope.builtin").commands()
      end,
      desc = "Commands",
    },
    {
      "<leader>sb",
      function()
        require("telescope.builtin").buffers()
      end,
      desc = "Buffers",
    },
    {
      "<leader>/",
      function()
        require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end,
      desc = "[/] Fuzzily search in current buffer",
    },
    {
      "<leader>s/",
      function()
        require("telescope.builtin").live_grep({
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        })
      end,
      desc = "[S]earch [/] in Open Files",
    },
    {
      "<leader>sn",
      function()
        require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "[S]earch [N]eovim files",
    },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local trouble = require("trouble.sources.telescope")
    -- local icons = require("config.icons")

    require("telescope").load_extension("cmdline")
    vim.api.nvim_set_keymap("n", "Q", ":Telescope cmdline<CR>", { noremap = true, desc = "Cmdline" })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "TelescopeResults",
      callback = function(ctx)
        vim.api.nvim_buf_call(ctx.buf, function()
          vim.fn.matchadd("TelescopeParent", "\t\t.*$")
          vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
        end)
      end,
    })

    local function document_symbols_for_selected(prompt_bufnr)
      local action_state = require("telescope.actions.state")
      local actions = require("telescope.actions")
      local entry = action_state.get_selected_entry()

      if entry == nil then
        print("No file selected")
        return
      end

      actions.close(prompt_bufnr)

      vim.schedule(function()
        local bufnr = vim.fn.bufadd(entry.path)
        vim.fn.bufload(bufnr)

        local params = { textDocument = vim.lsp.util.make_text_document_params(bufnr) }

        vim.lsp.buf_request(bufnr, "textDocument/documentSymbol", params, function(err, result, _, _)
          if err then
            print("Error getting document symbols: " .. vim.inspect(err))
            return
          end

          if not result or vim.tbl_isempty(result) then
            print("No symbols found")
            return
          end

          local function flatten_symbols(symbols, parent_name)
            local flattened = {}
            for _, symbol in ipairs(symbols) do
              local name = symbol.name
              if parent_name then
                name = parent_name .. "." .. name
              end
              table.insert(flattened, {
                name = name,
                kind = symbol.kind,
                range = symbol.range,
                selectionRange = symbol.selectionRange,
              })
              if symbol.children then
                local children = flatten_symbols(symbol.children, name)
                for _, child in ipairs(children) do
                  table.insert(flattened, child)
                end
              end
            end
            return flattened
          end

          local flat_symbols = flatten_symbols(result)

          -- Define highlight group for symbol kind
          vim.cmd([[highlight TelescopeSymbolKind guifg=#61AFEF]])

          require("telescope.pickers")
              .new({}, {
                prompt_title = "Document Symbols: " .. vim.fn.fnamemodify(entry.path, ":t"),
                finder = require("telescope.finders").new_table({
                  results = flat_symbols,
                  entry_maker = function(symbol)
                    local kind = vim.lsp.protocol.SymbolKind[symbol.kind] or "Other"
                    return {
                      value = symbol,
                      display = function(entry)
                        local display_text = string.format("%-50s %s", entry.value.name, kind)
                        return display_text, { { { #entry.value.name + 1, #display_text }, "TelescopeSymbolKind" } }
                      end,
                      ordinal = symbol.name,
                      filename = entry.path,
                      lnum = symbol.selectionRange.start.line + 1,
                      col = symbol.selectionRange.start.character + 1,
                    }
                  end,
                }),
                sorter = require("telescope.config").values.generic_sorter({}),
                previewer = require("telescope.config").values.qflist_previewer({}),
                attach_mappings = function(_, map)
                  map("i", "<CR>", function(prompt_bufnr)
                    local selection = action_state.get_selected_entry()
                    actions.close(prompt_bufnr)
                    vim.cmd("edit " .. selection.filename)
                    vim.api.nvim_win_set_cursor(0, { selection.lnum, selection.col - 1 })
                  end)
                  return true
                end,
              })
              :find()
        end)
      end)
    end

    telescope.setup({
      file_ignore_patterns = { ".git/", "node_modules/", "vendor/" },
      defaults = {
        mappings = {
          i = {
            ["<esc>"] = actions.close,
            ["<C-t>"] = trouble.open,
            ["<C-s>"] = document_symbols_for_selected,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-q>"] = actions.send_to_qflist,
            ["<C-x>"] = actions.send_selected_to_qflist,
          },
          n = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-q>"] = actions.send_to_qflist,
            ["<C-x>"] = actions.send_selected_to_qflist,
            ["<C-t>"] = trouble.open_with_trouble,
            ["<C-s>"] = document_symbols_for_selected,
          },
        },
        path_display = {
          "filename_first",
        },
        previewer = false,
        -- prompt_prefix = " " .. icons.ui.Telescope .. " ",
        -- selection_caret = icons.ui.BoldArrowRight .. " ",
        file_ignore_patterns = { "node_modules", "package-lock.json" },
        initial_mode = "insert",
        select_strategy = "reset",
        sorting_strategy = "ascending",
        color_devicons = true,
        set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
        layout_config = {
          prompt_position = "top",
          preview_cutoff = 120,
        },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
          "--glob=!.git/",
        },
      },
      pickers = {
        find_files = {
          previewer = false,
          -- path_display = formattedName,
          layout_config = {
            height = 0.4,
            prompt_position = "top",
            preview_cutoff = 120,
          },
        },
        git_files = {
          previewer = false,
          -- path_display = formattedName,
          layout_config = {
            height = 0.4,
            prompt_position = "top",
            preview_cutoff = 120,
          },
        },
        buffers = {
          mappings = {
            i = {
              ["<c-d>"] = actions.delete_buffer,
            },
            n = {
              ["<c-d>"] = actions.delete_buffer,
            },
          },
          previewer = false,
          initial_mode = "normal",
          -- theme = "dropdown",
          layout_config = {
            height = 0.4,
            width = 0.6,
            prompt_position = "top",
            preview_cutoff = 120,
          },
        },
        current_buffer_fuzzy_find = {
          previewer = true,
          layout_config = {
            prompt_position = "top",
            preview_cutoff = 120,
          },
        },
        live_grep = {
          only_sort_text = true,
          previewer = true,
        },
        grep_string = {
          only_sort_text = true,
          previewer = true,
        },
        lsp_references = {
          show_line = false,
          previewer = true,
        },
        treesitter = {
          show_line = false,
          previewer = true,
        },
        colorscheme = {
          enable_preview = true,
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,                   -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true,    -- override the file sorter
          case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
        },
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      },
    })

    -- Enable Telescope extensions if they are installed
    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")
    pcall(require("telescope").load_extension, "notify")
    pcall(require("telescope").load_extension, "package_info")
  end,
}
