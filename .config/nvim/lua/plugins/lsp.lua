return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{
				"williamboman/mason.nvim",
				config = true,
			},
			{
				"j-hui/fidget.nvim",
				opts = {},
			},
			"williamboman/mason-lspconfig.nvim",
			"b0o/schemastore.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local lspconfig = require("lspconfig")
			local mason = require("mason")
			local mason_lspconfig = require("mason-lspconfig")
			local mason_tool_installer = require("mason-tool-installer")
			local servers = require("plugins.lsp.servers")
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local capabilities = cmp_nvim_lsp.default_capabilities()

			mason.setup({
				ui = {
					border = "rounded",
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})

			mason_lspconfig.setup({
				ensure_installed = vim.tbl_keys(servers or {}),
			})

			mason_tool_installer.setup({
				ensure_installed = {
					"stylua",
				},
			})

			mason_lspconfig.setup_handlers({
				function(server_name)
					vim.api.nvim_echo({ { "Setting up LSP for " .. server_name, "Title" } }, true, {})
					lspconfig[server_name].setup({
						capabilities = capabilities,
					})
				end,

				["powershell_es"] = function()
					lspconfig["powershell_es"].setup({
						capabilities = capabilities,
						filetypes = servers["powershell_es"].filetypes,
						settings = servers["powershell_es"].settings,
						bundle_path = servers["powershell_es"].bundle_path,
						init_options = servers["powershell_es"].init_options,
					})
				end,

				["lua_ls"] = function()
					lspconfig["lua_ls"].setup({
						settings = servers["lua_ls"].settings,
					})
				end,

				["pylsp"] = function()
					lspconfig["pylsp"].setup({
						settings = servers["pylsp"].settings,
					})
				end,

				["html"] = function()
					lspconfig["html"].setup({
						filetypes = servers["html"].filetypes,
					})
				end,
			})

			vim.api.nvim_create_autocmd("lspattach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "lsp: " .. desc })
					end

					-- jump to the definition of the word under your cursor.
					--  this is where a variable was first declared, or where a function is defined, etc.
					--  to jump back, press <c-t>.
					map("gd", require("telescope.builtin").lsp_definitions, "[g]oto [d]efinition")

					-- find references for the word under your cursor.
					map("gr", require("telescope.builtin").lsp_references, "[g]oto [r]eferences")

					-- jump to the implementation of the word under your cursor.
					--  useful when your language has ways of declaring types without an actual implementation.
					map("gi", require("telescope.builtin").lsp_implementations, "[g]oto [i]mplementation")

					-- jump to the type of the word under your cursor.
					--  useful when you're not sure what type a variable is and you want to see
					--  the definition of its *type*, not where it was *defined*.
					map("<leader>d", require("telescope.builtin").lsp_type_definitions, "type [d]efinition")

					-- fuzzy find all the symbols in your current document.
					--  symbols are things like variables, functions, types, etc.
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[d]ocument [s]ymbols")

					-- fuzzy find all the symbols in your current workspace.
					--  similar to document symbols, except searches over your entire project.
					map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[w]orkspace [s]ymbols")

					-- rename the variable under your cursor.
					--  most language servers support renaming across files, etc.
					map("<leader>rn", vim.lsp.buf.rename, "[r]e[n]ame")

					-- execute a code action, usually your cursor needs to be on top of an error
					-- or a suggestion from your lsp for this to activate.
					map("<leader>ca", vim.lsp.buf.code_action, "[c]ode [a]ction", { "n", "x" })

					-- warn: this is not goto definition, this is goto declaration.
					--  for example, in c this would take you to the header.
					map("gd", vim.lsp.buf.declaration, "[g]oto [d]eclaration")

					map("<leader>p", require("telescope.builtin").lsp_document_symbols, "document symbols")
					map("<leader>ws", require("telescope.builtin").lsp_workspace_symbols, "workspace symbols")
					map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "workspace symbols")
					map("<leader>v", "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>",
						"goto definition in vertical split")

					-- the following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
						local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight",
							{ clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					-- The following code creates a keymap to toggle inlay hints in your
					-- code, if the language server you are using supports them
					--
					-- This may be unwanted, since they displace some of your code
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})
		end,
	},
}

--[[return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{
				"williamboman/mason.nvim",
				config = true,
			},
			{
				"j-hui/fidget.nvim",
				opts = {},
			},
			"williamboman/mason-lspconfig.nvim",
			"b0o/schemastore.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")
			local mason_lspconfig = require("mason-lspconfig")
			local servers = require("plugins.lsp.servers")
			local ensure_installed = vim.tbl_keys(servers or {})

			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			vim.list_extend(ensure_installed, {
				"stylua",
			})

			require("mason").setup({
				ui = {
					border = "rounded",
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})

			require("mason-lspconfig").setup({
				ensure_installed = ensure_installed,
			})
			require("lspconfig.ui.windows").default_options.border = "single"

			vim.api.nvim_create_autocmd("lspattach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "lsp: " .. desc })
					end

					-- jump to the definition of the word under your cursor.
					--  this is where a variable was first declared, or where a function is defined, etc.
					--  to jump back, press <c-t>.
					map("gd", require("telescope.builtin").lsp_definitions, "[g]oto [d]efinition")

					-- find references for the word under your cursor.
					map("gr", require("telescope.builtin").lsp_references, "[g]oto [r]eferences")

					-- jump to the implementation of the word under your cursor.
					--  useful when your language has ways of declaring types without an actual implementation.
					map("gi", require("telescope.builtin").lsp_implementations, "[g]oto [i]mplementation")

					-- jump to the type of the word under your cursor.
					--  useful when you're not sure what type a variable is and you want to see
					--  the definition of its *type*, not where it was *defined*.
					map("<leader>d", require("telescope.builtin").lsp_type_definitions, "type [d]efinition")

					-- fuzzy find all the symbols in your current document.
					--  symbols are things like variables, functions, types, etc.
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[d]ocument [s]ymbols")

					-- fuzzy find all the symbols in your current workspace.
					--  similar to document symbols, except searches over your entire project.
					map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[w]orkspace [s]ymbols")

					-- rename the variable under your cursor.
					--  most language servers support renaming across files, etc.
					map("<leader>rn", vim.lsp.buf.rename, "[r]e[n]ame")

					-- execute a code action, usually your cursor needs to be on top of an error
					-- or a suggestion from your lsp for this to activate.
					map("<leader>ca", vim.lsp.buf.code_action, "[c]ode [a]ction", { "n", "x" })

					-- warn: this is not goto definition, this is goto declaration.
					--  for example, in c this would take you to the header.
					map("gd", vim.lsp.buf.declaration, "[g]oto [d]eclaration")

					map("<leader>p", require("telescope.builtin").lsp_document_symbols, "document symbols")
					map("<leader>ws", require("telescope.builtin").lsp_workspace_symbols, "workspace symbols")
					map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "workspace symbols")
					map("<leader>v", "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>",
						"goto definition in vertical split")

					-- the following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
						local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight",
							{ clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					-- The following code creates a keymap to toggle inlay hints in your
					-- code, if the language server you are using supports them
					--
					-- This may be unwanted, since they displace some of your code
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			local wk = require("which-key")
			wk.add({
				{ "<leader>la", vim.lsp.buf.code_action,                           desc = "Code Action" },
				{ "<leader>lA", vim.lsp.buf.range_code_action,                     desc = "Range Code Actions" },
				{ "<leader>ls", vim.lsp.buf.signature_help,                        desc = "Display Signature Information" },
				{ "<leader>lr", vim.lsp.buf.rename,                                desc = "Rename all references" },
				{ "<leader>lf", vim.lsp.buf.format,                                desc = "Format" },
				{ "<leader>li", require("telescope.builtin").lsp_implementations,  desc = "Implementation" },
				{ "<leader>lw", require("telescope.builtin").diagnostics,          desc = "Diagnostics" },
				{ "<leader>lc", require("config.utils").copyFilePathAndLineNumber, desc = "Copy File Path and Line Number" },

				-- W = {
				--   name = "+Workspace",
				--   a = { vim.lsp.buf.add_workspace_folder, "Add Folder" },
				--   r = { vim.lsp.buf.remove_workspace_folder, "Remove Folder" },
				--   l = {
				--     function()
				--       print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				--     end,
				--     "List Folders",
				--   },
				-- },

				{ "<leader>Wa", vim.lsp.buf.add_workspace_folder,                  desc = "Workspace Add Folder" },
				{ "<leader>Wr", vim.lsp.buf.remove_workspace_folder,               desc = "Workspace Remove Folder" },
				{
					"<leader>Wl",
					function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end,
					desc = "Workspace List Folders",
				},
			})

			mason_lspconfig.setup_handlers({
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
						-- on_attach = require("plugins.lsp.on_attach").on_attach,
						settings = (require("plugins.lsp.servers")[server_name]).settings,
						filetypes = (require("plugins.lsp.servers")[server_name] or {}).filetypes,
					})
				end,
			})
		end,
	},
}]]
