_G.tvim = {
	env_prefix = "TESTNVIM_",
	app_name_supported = function()
		if os.getenv("TESTNVIM_APPNAME_SUPPORTED") == "1" then
			return true
		else
			return false
		end
	end,
}

vim.opt.rtp:append(os.getenv(_G.tvim.env_prefix .. "PLENARY_DIR"))
vim.opt.rtp:append(os.getenv(_G.tvim.env_prefix .. "STRUCTLOG_DIR"))

if not _G.tvim.app_name_supported() then
	-- TODO update runtime path
	-- override vim.fn.stdpath
else
	-- we gucci
end

local bootstrap = require("tvim.bootstrap")

bootstrap.load_lazy()
vim.opt.termguicolors = true
-- do not remove the colorscheme!
vim.cmd([[colorscheme tokyonight]])
bootstrap.load_structlog()
bootstrap.load_user_conf()

print(vim.inspect(vim.opt.rtp:get()))
local logger = require("structlog").get_logger("tvim")
logger:info("Tvim initialized")
