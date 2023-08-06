-- bootstrap lazy
local state = vim.fn.stdpath("state")
local pack_path = state .. "/after/pack/lazy/opt"
local lazypath = pack_path .. "/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--single-branch",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end

vim.opt.runtimepath:prepend(lazypath)

-- install plugins
local plugins = {
	-- do not remove the colorscheme!
	"folke/tokyonight.nvim",
	"folke/which-key.nvim",
}
require("lazy").setup(plugins, {
	install = {
		missing = true,
	},
	lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
	root = pack_path,
})

local log = require("structlog")

log.configure({
	tvim = {
		pipelines = {
			{
				level = log.level.INFO,
				processors = {
					log.processors.StackWriter({ "line", "file" }, { max_parents = 0, stack_level = 0 }),
					log.processors.Timestamper("%H:%M:%S"),
				},
				formatter = log.formatters.FormatColorizer( --
					"%s [%s] %s: %-30s",
					{ "timestamp", "level", "logger_name", "msg" },
					{ level = log.formatters.FormatColorizer.color_level() }
				),
				sink = log.sinks.Console(),
			},
			{
				level = log.level.DEBUG,
				processors = {
					log.processors.StackWriter({ "line", "file" }, { max_parents = 0, stack_level = 1 }),
					log.processors.Timestamper("%H:%M:%S"),
				},
				formatter = log.formatters.Format( --
					"%s [%s] %s: %-30s",
					{ "timestamp", "level", "logger_name", "msg" }
				),
				sink = log.sinks.File(os.getenv("TESTNVIM_LOG_DIR") .. "/debug.log"),
			},
			{
				level = log.level.TRACE,
				processors = {
					log.processors.StackWriter({ "line", "file" }, { max_parents = 3, stack_level = 5 }),
					log.processors.Timestamper("%H:%M:%S"),
				},
				formatter = log.formatters.Format( --
					"%s [%s] %s: %-30s",
					{ "timestamp", "level", "logger_name", "msg" }
				),
				sink = log.sinks.File(os.getenv("TESTNVIM_LOG_DIR") .. "/trace.log"),
			},
		},
	},
})

-- load user config
local user_config = require(os.getenv("TESTNVIM_CONFIG_DIR") .. "config.lua")

for _, path in ipairs(user_config.plugin_paths) do
	vim.opt.runtimepath:append(path)
end

-- execute any logic in user config
require(os.getenv("TESTNVIM_CONFIG_DIR") .. "init.lua")

local logger = log.get_logger("tvim")
logger:info("Tvim initialized")

-- add anything else here
vim.opt.termguicolors = true
-- do not remove the colorscheme!
vim.cmd([[colorscheme tokyonight]])
