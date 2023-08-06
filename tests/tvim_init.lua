local path_sep = vim.loop.os_uname().version:match("Windows") and "\\" or "/"
local base_dir = vim.fn.stdpath("state")
local tests_dir = base_dir .. path_sep .. "tests"

vim.opt.rtp:append(base_dir)
vim.opt.rtp:append(tests_dir)
print(vim.inspect(vim.opt.rtp:get()))

local bootstrap = require("tvim.bootstrap")
bootstrap.load_lazy()
bootstrap.load_structlog()
bootstrap.load_user_conf()
-- NOTE: careful about name collisions
-- see https://github.com/nvim-lualine/lualine.nvim/pull/621
require("tests.config.helpers")
