local M = {}

local logger = require("structlog").get_logger("tvim")

---Adds the plugin paths to the runtimepath
function M.add_plugin_paths_to_rtp()
	local user_config = require("userconf.config")

	if user_config.plugin_paths == nil then
		logger:warn("no plugin paths found in user config")
		return
	end
	for _, path in ipairs(user_config.plugin_paths) do
		if type(path) == "table" then
			if path.path == nil then
				return
			end
			if path.prepend then
				vim.opt.runtimepath:prepend(path.path)
			else
				vim.opt.runtimepath:append(path.path)
			end
		elseif type(path) == "string" then
			vim.opt.runtimepath:append(path)
		else
			error("invalid plugin path: " .. type(path))
		end
	end
end

return M
