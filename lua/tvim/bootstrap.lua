_G.tvim = {
	nvim_appname_supported = true,
}

if vim.fn.has("nvim-0.9") ~= 1 then
	_G.tvim.nvim_appname_supported = false
	vim.fn.sdtpath = function(what)
		if what == "data" then
			return os.getenv("TESTNVIM_DATA_DIR")
		end
	end
end

local M = {}

function M.load_lazy()
	-- bootstrap lazy
	local data = vim.fn.stdpath("data")
	local pack_path = data .. "/after/pack/lazy/opt"
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

	vim.opt.rtp:prepend(pack_path)
	vim.opt.rtp:prepend(lazypath)

	---@return string lazy_path
	function _G.lazy_rtp()
		return lazypath
	end
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
		lockfile = vim.fn.stdpath("cache") .. "/lazy-lock.json",
		root = pack_path,
		performance = {
			cache = {
				enabled = true,
			},
			reset_packpath = true, -- reset the package path to improve startup time
			rtp = {
				reset = false, -- reset the runtime path to $VIMRUNTIME and your config directory
				---@type string[]
				paths = {}, -- add any custom paths here that you want to includes in the rtp
				---@type string[] list any plugins you want to disable here
				disabled_plugins = {
					-- "gzip",
					-- "matchit",
					-- "matchparen",
					-- "netrwPlugin",
					-- "tarPlugin",
					-- "tohtml",
					-- "tutor",
					-- "zipPlugin",
				},
			},
		},
	})
end

function M.load_structlog()
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
end

function M.load_user_conf()
	local config_path = vim.fn.stdpath("config")

	---@return string|nil config_path
	function _G.user_conf()
		return config_path
	end

	vim.opt.rtp:prepend(config_path)

	local tvim_util = require("tvim.util")

	-- load user config
	tvim_util.add_plugin_paths_to_rtp()

	-- execute any logic in user config
	require("userconf")
end
return M
