return {
	"TheLeoP/powershell.nvim",
	config = function()
		require("powershell").setup({
			bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
			init_options = {
				enableProfileLoading = false,
			},
			settings = {
				codeFormatting = {
					preset = "OTBS",
				},
			},
		})
	end,
}
