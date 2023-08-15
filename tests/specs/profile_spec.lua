local a = require("plenary.async_lib.tests")
local rtp_list = vim.opt.rtp:get()

a.describe("Profile is retrievable and rtp state is correct:", function()
	a.it("data profile ", function()
		local data_dir = vim.fn.stdpath("data")
		local std_data_dir = os.getenv("TESTNVIM_DATA_PROFILE")

		assert.equal(data_dir, std_data_dir)
		assert.truthy(vim.tbl_contains(rtp_list, data_dir))
	end)

	a.it("config profile", function()
		local config_dir = vim.fn.stdpath("config")
		local std_config_dir = os.getenv("TESTNVIM_CONFIG_PROFILE")

		assert.equal(config_dir, std_config_dir)
		assert.truthy(vim.tbl_contains(rtp_list, config_dir))
	end)

	a.it("cache profile", function()
		local cache_dir = vim.fn.stdpath("cache")
		local std_cache_dir = os.getenv("TESTNVIM_CACHE_PROFILE")

		assert.equal(cache_dir, std_cache_dir)
		assert.falsy(vim.tbl_contains(rtp_list, cache_dir))
	end)

	a.it("log profile", function()
		local log_dir = vim.fn.stdpath("log")
		local std_log_dir = os.getenv("TESTNVIM_LOG_PROFILE")

		assert.equal(log_dir, std_log_dir)
		assert.falsy(vim.tbl_contains(rtp_list, log_dir))
	end)
end)
