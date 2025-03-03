return {
	"echasnovski/mini.nvim",
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
			"jump",
			"notify",
			"pairs",
			-- "pick",
			"splitjoin",
			"statusline",
			"surround",
			"tabline",
			"trailspace",
		}

		for _, module in ipairs(mini_modules) do
			require("mini." .. module).setup()
		end
		require("mini.ai").setup({ n_lines = 500 })

		local statusline = require("mini.statusline")
		statusline.setup({ use_icons = vim.g.have_nerd_font })

		-- You can configure sections in the statusline by overriding their
		-- default behavior. For example, here we set the section for
		-- cursor location to LINE:COLUMN
		---@diagnostic disable-next-line: duplicate-set-field
		statusline.section_location = function()
			return "%2l:%-2v"
		end

		-- trim with backspace
		vim.keymap.set("n", "<BS>", ":lua MiniTrailspace.trim()<CR>")

		-- minifiles
		local minifiles_toggle = function(...)
			if not MiniFiles.close() then
				MiniFiles.open(...)
			end
		end
		vim.keymap.set("n", "-", minifiles_toggle, { desc = "Toggle MiniFiles" })
	end,
}
