---@class test_user_cunfig
---@field plugin_paths table<string|table<string,string|boolean>|nil>
local M = {
	plugin_paths = {
		-- add any full paths to your plugins here
		{
			-- choose whether to prepend or append to rtp
			prepend = true,
			path = vim.fn.stdpath("config") .. "/plugins",
		},
		{
			-- choose whether to prepend or append to rtp
			prepend = false,
			path = vim.fn.stdpath("config") .. "/yet_another_plugin_path",
		},
		vim.fn.stdpath("config") .. "/another_plugin_path",
	},
}

return M
