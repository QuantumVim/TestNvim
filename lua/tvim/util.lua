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

---Modifies the runtimepath by removing standard paths from `vim.call("stdpath", what)` with `vim.fn.stdpath(what)`
---@param stds string[]|nil @default: { "config", "data" }
---@param expands string[][]|nil @default: { {}, { "site", "after" }, { "site" }, { "after" } }
---@return vim.opt.runtimepath
function M.modify_runtime_path(stds, expands)
	stds = stds or { "config", "data" }
	expands = expands or { {}, { "site", "after" }, { "site" }, { "after" } }
	---@type vim.opt.runtimepath
	local rtp = vim.opt.rtp:get()

	for _, what in ipairs(stds) do
		for _, expand in ipairs(expands) do
			if #expand == 0 then
				---@diagnostic disable-next-line: param-type-mismatch
				if vim.tbl_contains(rtp, vim.call("stdpath", what)) then
					-- remove
					---@diagnostic disable-next-line: param-type-mismatch
					rtp:remove(vim.call("stdpath", what))
				end
				if not vim.tbl_contains(rtp, vim.fn.stdpath(what)) then
					-- add
					rtp:prepend(vim.fn.stdpath(what))
				end
			else
				if
					-- remove
					vim.tbl_contains(
						rtp,
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
						rtp,
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
return M
