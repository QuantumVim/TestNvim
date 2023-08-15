local a = require("plenary.async_lib.tests")
local rtp_list = vim.opt.rtp:get()

a.describe("Essential TestNvim plugins are available:", function()
	a.it("Plenary", function()
		local plenary_dir = vim.fn.stdpath("plenary")
		local std_plenary = os.getenv("TESTNVIM_PLENARY_DIR")

		assert.equal(plenary_dir, std_plenary)
		assert.truthy(vim.tbl_contains(rtp_list, plenary_dir))
	end)

	a.it("Structlog", function()
		local structlog_dir = vim.fn.stdpath("structlog")
		local std_structlog = os.getenv("TESTNVIM_STRUCTLOG_DIR")

		assert.equal(structlog_dir, std_structlog)
		assert.truthy(vim.tbl_contains(rtp_list, structlog_dir))
	end)
end)
