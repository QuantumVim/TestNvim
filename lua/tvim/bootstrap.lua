local M = {}

--- Inintialize tvim with lazy.nvim
function M.init()
	-- bootstrap lazy
	local pack_path = vim.fn.stdpath("pack")
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
		lockfile = vim.fn.stdpath("log") .. "/lazy-lock.json",
		root = pack_path,
		performance = {
			cache = {
				enabled = true,
			},
			reset_packpath = false, -- reset the package path to improve startup time
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
		readme = {
			enabled = true,
			root = vim.fn.stdpath("data") .. "/lazy/readme",
			files = { "README.md", "lua/**/README.md" },
			-- only generate markdown helptags for plugins that dont have docs
			skip_if_doc_exists = true,
		},
	})
end

---Bootstrap tvim with rtp modifications
function M.bootstrap()
	-- these have to be added after lazy setup
	vim.opt.rtp:prepend(
		join_paths(
			os.getenv(_G.tvim.env_prefix .. "STATE_DIR"),
			"site",
			"after"
		)
	)
	vim.opt.rtp:prepend(
		join_paths(os.getenv(_G.tvim.env_prefix .. "STATE_DIR"), "site")
	)
	vim.opt.rtp:prepend(
		join_paths(os.getenv(_G.tvim.env_prefix .. "STATE_DIR"), "after")
	)

	-- any calls that require state in rtp follow here
	local util = require("tvim.util")
	if not _G.tvim.app_name_supported() then
		vim.opt.rtp = util.modify_runtime_path()
	end
end

---Load structlog
function M.load_structlog()
	local log = require("structlog")

	log.configure({
		tvim = {
			pipelines = {
				{
					level = log.level.INFO,
					processors = {
						log.processors.StackWriter(
							{ "line", "file" },
							{ max_parents = 0, stack_level = 0 }
						),
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
						log.processors.StackWriter(
							{ "line", "file" },
							{ max_parents = 0, stack_level = 1 }
						),
						log.processors.Timestamper("%H:%M:%S"),
					},
					formatter = log.formatters.Format( --
						"%s [%s] %s: %-30s",
						{ "timestamp", "level", "logger_name", "msg" }
					),
					sink = log.sinks.File(
						vim.fn.stdpath("log") .. "/debug.log"
					),
				},
				{
					level = log.level.TRACE,
					processors = {
						log.processors.StackWriter(
							{ "line", "file" },
							{ max_parents = 3, stack_level = 5 }
						),
						log.processors.Timestamper("%H:%M:%S"),
					},
					formatter = log.formatters.Format( --
						"%s [%s] %s: %-30s",
						{ "timestamp", "level", "logger_name", "msg" }
					),
					sink = log.sinks.File(
						vim.fn.stdpath("log") .. "/trace.log"
					),
				},
			},
		},
	})
end

---Load and execute user config
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
