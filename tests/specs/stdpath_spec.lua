local a = require("plenary.async_lib.tests")
local uv = vim.loop
local path_sep = uv.os_uname().version:match("Windows") and "\\" or "/"
local rtp_list = vim.opt.rtp:get()

a.describe(
	"Testnvim base XDG is retrievable and rtp state is correct for Nvim 0.9 and below:",
	function()
		a.it("data home absent", function()
			local data_base = os.getenv("TESTNVIM_DATA_DIR")
			local tvim_xdg = os.getenv("XDG_DATA_HOME") .. path_sep .. "tvim"

			assert.equal(data_base, tvim_xdg)
			assert.falsy(vim.tbl_contains(rtp_list, data_base))
		end)

		a.it("state home present", function()
			local tvim_std = vim.fn.stdpath("state")
			local tvim_xdg_env = os.getenv("XDG_STATE_HOME")
				.. path_sep
				.. "tvim"
			local tvim_state_env = os.getenv("TESTNVIM_STATE_DIR")

			assert.equal(tvim_std, tvim_xdg_env)
			assert.equal(tvim_std, tvim_state_env)
			assert.truthy(vim.tbl_contains(rtp_list, tvim_std))
			assert.truthy(vim.tbl_contains(rtp_list, tvim_xdg_env))
		end)

		a.it("config home absent", function()
			local tvim_xdg_env = os.getenv("XDG_CONFIG_HOME")
				.. path_sep
				.. "tvim"
			local tvim_config_env = os.getenv("TESTNVIM_CONFIG_DIR")

			assert.equal(tvim_xdg_env, tvim_config_env)
			assert.falsy(vim.tbl_contains(rtp_list, tvim_xdg_env))
		end)

		a.it("cache home absent", function()
			local tvim_xdg_env = os.getenv("XDG_CACHE_HOME")
				.. path_sep
				.. "tvim"
			local tvim_cache_env = os.getenv("TESTNVIM_CACHE_DIR")

			assert.equal(tvim_xdg_env, tvim_cache_env)
			assert.falsy(vim.tbl_contains(rtp_list, tvim_xdg_env))
		end)

		a.it("log home absent", function()
			local tvim_xdg_env = os.getenv("XDG_LOG_HOME") .. path_sep .. "tvim"
			local tvim_log_env = os.getenv("TESTNVIM_LOG_DIR")
			assert.equal(tvim_xdg_env, tvim_log_env)
			assert.falsy(vim.tbl_contains(rtp_list, tvim_xdg_env))
		end)
	end
)
