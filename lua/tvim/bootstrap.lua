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

	local opts = {
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
	}

	require("lazy").setup(
		vim.tbl_deep_extend("force", plugins, _G.tvim.user_config.lazy.specs),
		vim.tbl_deep_extend("force", opts, _G.tvim.user_config.lazy.opts)
	)
end

--Modifies the runtimepath by removing standard paths from `vim.call("stdpath", what)` with `vim.fn.stdpath(what)`
---@param stds string[]|nil @default: { "config", "data" }
---@param expands string[][]|nil @default: { {}, { "site", "after" }, { "site" }, { "after" } }
---@return vim.opt.runtimepath
function M.bootstrap(stds, expands)
	stds = stds or { "config", "data" }
	expands = expands or { {}, { "site", "after" }, { "site" }, { "after" } }
	---@type vim.opt.runtimepath
	local rtp_paths = vim.opt.rtp:get()
	local rtp = vim.opt.rtp

	for _, what in ipairs(stds) do
		for _, expand in ipairs(expands) do
			if #expand == 0 then
				---@diagnostic disable-next-line: param-type-mismatch
				if vim.tbl_contains(rtp_paths, vim.call("stdpath", what)) then
					-- remove
					---@diagnostic disable-next-line: param-type-mismatch
					print(vim.call("stdpath", what))
					rtp:remove(vim.call("stdpath", what))
				end
				if not vim.tbl_contains(rtp_paths, vim.fn.stdpath(what)) then
					-- add
					rtp:prepend(vim.fn.stdpath(what))
				end
			else
				if
					-- remove
					vim.tbl_contains(
						rtp_paths,
						_G.join_paths(
							---@diagnostic disable-next-line: param-type-mismatch
							vim.call("stdpath", what),
							unpack(expand)
						)
					)
				then
					rtp:remove(_G.join_paths(
						---@diagnostic disable-next-line: param-type-mismatch
						vim.call("stdpath", what),
						unpack(expand)
					))
				end
				if
					not vim.tbl_contains(
						rtp_paths,
						_G.join_paths(vim.fn.stdpath(what), unpack(expand))
					)
				then
					-- add
					rtp:prepend(
						_G.join_paths(vim.fn.stdpath(what), unpack(expand))
					)
				end
			end
		end
	end
	return rtp
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
	local user_config = require("userconf.config")

	print(vim.inspect(user_config))
	_G.tvim.user_config = user_config
end

function M.process_user_config()
	local tvim_util = require("tvim.util")

	local user_config = require("userconf.config")
	-- load user config
	tvim_util.add_plugin_paths_to_rtp()

	if user_config then
		if user_config.colorscheme then
			vim.cmd("colorscheme " .. user_config.colorscheme)
		else
			vim.cmd("colorscheme " .. "tokyonight")
		end
		if user_config.commands then
			local common_opts = { force = true }
			for _, cmd in pairs(user_config.commands) do
				local opts =
					vim.tbl_deep_extend("force", common_opts, cmd.opts or {})
				vim.api.nvim_create_user_command(cmd.name, cmd.fn, opts)
			end
		end
	end

	-- execute any logic in user config
	require("userconf")
end
return M
