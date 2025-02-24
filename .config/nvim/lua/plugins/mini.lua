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
      "jump",
      "jump2d",
      "pairs",
      "pick",
      "splitjoin",
      "statusline",
      "surround",
      "trailspace"
    }

    for _, module in ipairs(mini_modules) do
      require("mini." .. module).setup()
    end

  end
}
