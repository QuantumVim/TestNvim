local a = require("plenary.async_lib.tests")
local rtp_list = vim.opt.rtp:get()

a.describe("initial start", function()
	a.it("should be able to read lazy directories from rtp", function()
		assert.truthy(
			vim.tbl_contains(rtp_list, vim.fn.stdpath("pack") .. "/lazy.nvim")
		)
	end)

	a.it("should be able to read user directories from rtp", function()
		assert.truthy(vim.tbl_contains(rtp_list, vim.fn.stdpath("config")))
	end)

	a.it("should be able to add WIP plugins to rtp", function()
		local user_config = require("userconf.config")

		local tvim_util = require("tvim.util")
		tvim_util.add_plugin_paths_to_rtp()
		for _, p in ipairs(user_config.plugin_paths) do
			if type(p) == "table" then
				p = p.path
			end
			assert.truthy(vim.tbl_contains(rtp_list, p))
		end
	end)
end)
