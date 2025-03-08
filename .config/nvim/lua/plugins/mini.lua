return { 
	'echasnovski/mini.nvim',
	version = false,
	config = function()
    local mini_specs = {
      'basics',
      'icons',
      'notify',
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

    -- minifiles
		local minifiles_toggle = function(...)
			if not MiniFiles.close() then
				MiniFiles.open(...)
			end
		end
    require('mini.files').setup({
      vim.keymap.set('n', '-', minifiles_toggle, { desc = "Toggle Minifiles" })
    })
    
    -- trim with backspace
		vim.keymap.set("n", "<BS>", ":lua MiniTrailspace.trim()<CR>")
	end
}
