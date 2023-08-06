---@class user_cunfig
---@field plugin_paths string[]|table<string, string>
local M = {
	plugin_paths = {
		-- add any full paths to your plugins here
		{
			-- choose whether to prepend or append to rtp
			prepend = true,
			path = nil,
		},
	},
}

return M
