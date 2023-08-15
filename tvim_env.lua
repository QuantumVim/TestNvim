---@class tvim
---@field env tvim.env
---@field app_name_supported fun():boolean
---@field user_config user_config
_G.tvim = {
	---@class tvim.env
	---@field tvim_prefix string
	---@field tvim_suffix string
	---@field user_suffix string
	env = {
		tvim_prefix = "TESTNVIM_",
		tvim_suffix = "_DIR",
		user_suffix = "_PROFILE",
	},
	app_name_supported = function()
		return vim.fn.has("nvim-0.9") == 1
	end,
}

local uv = vim.loop
local path_sep = uv.os_uname().version:match("Windows") and "\\" or "/"

function _G.join_paths(...)
	local result = table.concat({ ... }, path_sep)
	return result
end

---@param what string
---@return string|nil
vim.fn.stdpath = function(what)
	local get_env_var = os.getenv
	local env_name = _G.tvim.env.tvim_prefix
		.. what:upper()
		.. _G.tvim.env.tvim_suffix
	local user_env_name = _G.tvim.env.tvim_prefix
		.. what:upper()
		.. _G.tvim.env.user_suffix

	if what == "config" then
		return get_env_var(user_env_name)
	end

	if what == "data" then
		return get_env_var(user_env_name)
	end

	if what == "cache" then
		return get_env_var(user_env_name)
	end

	if what == "log" then
		return get_env_var(user_env_name)
	end

	if what == "state" then
		return get_env_var(env_name)
	end

	if what == "pack" then
		return get_env_var(env_name)
	end

	if what == "plenary" then
		return get_env_var(env_name)
	end

	if what == "structlog" then
		return get_env_var(env_name)
	end

	local other = get_env_var(env_name)

	if not other then
		---@diagnostic disable-next-line: param-type-mismatch
		return vim.call("stdpath", what)
	else
		return other
	end
end
