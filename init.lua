-- bootstrap lazy
local state = vim.fn.stdpath("state")
local pack_path = state .. "/after/pack/lazy/opt"
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

vim.opt.runtimepath:prepend(lazypath)

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
	lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
	root = pack_path,
})

-- add anything else here
vim.opt.termguicolors = true
-- do not remove the colorscheme!
vim.cmd([[colorscheme tokyonight]])
