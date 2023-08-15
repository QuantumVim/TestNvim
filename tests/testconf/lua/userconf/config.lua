---@class user_config
---@field plugin_paths table
---@field colorscheme string
---@field commands table
---@field lazy user_config.lazy
local M = {
	plugin_paths = {
		"/path/to/plugin_one",
		-- add any full paths to your plugins here
		{
			-- choose whether to prepend or append to rtp
			prepend = true,
			path = "/path/to/plugin_two",
		},
	},
	colorscheme = "tokyonight",
	commands = {
		-- name = "MyCoolCommand",
		-- fn = function ()
		--
		-- end
	},
	---@class user_config.lazy
	---@field opts table https://github.com/folke/lazy.nvim#%EF%B8%8F-configuration
	---@field specs table https://github.com/folke/lazy.nvim#examples
	lazy = {
		opts = {},
		specs = {},
	},
}

return M
