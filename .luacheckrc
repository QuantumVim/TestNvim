---@diagnostic disable
-- vim: ft=lua tw=80

stds.nvim = {
	globals = {
		"user",
		"reload",
		vim = { fields = { "g" } },
		"TERMINAL",
		"USER",
		"C",
		"Config",
		"WORKSPACE_PATH",
		"JAVA_LS_EXECUTABLE",
		"MUtils",
		"USER_CONFIG_PATH",
		"tvim",
		"join_paths",
		os = { fields = { "capture" } },
	},
	read_globals = {
		"tvim",
		"jit",
		"os",
		"path_sep",
		"vim",
		"join_paths",
	},
}
std = "lua51+nvim"

files["tests/*_spec.lua"].std = "lua51+nvim+busted"
files["utils/conf/**/*.lua"].std = "lua51+nvim+busted"

-- Don't report unused self arguments of methods.
self = false

-- Rerun tests only if their modification time changed.
cache = true

ignore = {
	"631", -- max_line_length
	"212/_.*", -- unused argument, for vars with "_" prefix
}
