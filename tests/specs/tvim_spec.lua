local a = require("plenary.async_lib.tests")

a.describe("initial start", function()
	a.it("should start", function()
		assert.truthy(true)
	end)
	a.it("NVIM_APPNAME variable should be set", function()
		assert.truthy(os.getenv("NVIM_APPNAME") ~= nil)
	end)
	a.it("should be able to read lazy directories from rtp", function()
		local rtp_list = vim.opt.rtp:get()
		assert.truthy(vim.tbl_contains(rtp_list, _G.lazy_rtp()))
	end)
	a.it("should be able to read user directories from rtp", function()
		local rtp_list = vim.opt.rtp:get()
		print(vim.inspect(rtp_list))
		assert.truthy(vim.tbl_contains(rtp_list, _G.user_conf()))
	end)
	a.it("should be able to add WIP plugins to rtp", function()
		local rtp_list = vim.opt.rtp:get()
		local user_config = require("userconf.config")

		local path = vim.fn.stdpath("cache")
		local wip_paths = {
			path .. "/wip0",
			path .. "/wip",
			path .. "/wip2",
		}
		user_config.plugin_paths = {
			{
				path = wip_paths[1],
			},
			{
				prepend = true,
				path = wip_paths[2],
			},
			wip_paths[3],
		}
		local tvim_util = require("tvim.util")
		tvim_util.add_plugin_paths_to_rtp()
		for _, p in ipairs(wip_paths) do
			assert.truthy(vim.tbl_contains(rtp_list, p))
		end
	end)
end)
