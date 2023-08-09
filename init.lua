_G.tvim = {
	env_prefix = "TESTNVIM_",
	app_name_supported = function()
		return vim.fn.has("nvim-0.9") == 1
	end,
	user_config = {},
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
	local env_name = _G.tvim.env_prefix .. what:upper() .. "_DIR"
	local env_value = os.getenv(env_name)
	if env_value == nil then
		---@diagnostic disable-next-line: param-type-mismatch
		return vim.call("stdpath", what)
	end
	return env_value
end

vim.opt.rtp:append(vim.fn.stdpath("plenary"))
vim.opt.rtp:append(vim.fn.stdpath("structlog"))

-- tvim runtime path
vim.opt.rtp:prepend(vim.fn.stdpath("state"))
local bootstrap = require("tvim.bootstrap")
bootstrap.init()
bootstrap.bootstrap()

vim.opt.termguicolors = true

vim.cmd([[colorscheme tokyonight]])
bootstrap.load_structlog()
bootstrap.load_user_conf()

local logger = require("structlog").get_logger("tvim")
logger:info("Tvim initialized")
