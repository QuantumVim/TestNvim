---@class user_cunfig
---@field plugin_paths table<string|table<string,string|boolean>|nil>
local M = {
	-- will be merged with lazy: https://github.com/folke/lazy.nvim#%EF%B8%8F-configuration
	plugin_paths = {
		-- add any full paths to your plugins here
		{
			-- choose whether to prepend or append to rtp
			prepend = true,
			path = nil,
		},
	},
	colorscheme = "tokyonight",
	commands = {
		-- name = "MyCoolCommand",
		-- fn = function ()
		--
		-- end
	},
}

return M
