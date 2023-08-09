local a = require("plenary.async_lib.tests")

a.describe(
	"Nvim 0.9 and below should have correct env variables as well as the stdpaths",
	function()
		a.it("data home", function() end)

		a.it("state home", function() end)

		a.it("config home", function() end)

		a.it("cache home", function() end)

		a.it("log home", function() end)
	end
)
