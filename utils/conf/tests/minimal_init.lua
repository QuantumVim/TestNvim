-- tvim runtime path needs to be available from the start
vim.opt.rtp:prepend(os.getenv("TESTNVIM_STATE_DIR"))
require("tvim_env")

local uv = vim.loop
local path_sep = uv.os_uname().version:match("Windows") and "\\" or "/"
local base_dir = vim.fn.stdpath("config")
local tests_dir = base_dir .. path_sep .. "tests"

vim.opt.rtp:append(tests_dir)

vim.opt.rtp:append(vim.fn.stdpath("plenary"))
vim.opt.rtp:append(vim.fn.stdpath("structlog"))

local bootstrap = require("tvim.bootstrap")
-- runtime path modifications after lazy is done to avoid resetting necessary
vim.opt.rtp = bootstrap.bootstrap()

bootstrap.load_user_conf()
bootstrap.init()

bootstrap.process_user_config()

vim.opt.termguicolors = true
bootstrap.load_structlog()

-- NOTE: careful about name collisions
-- see https://github.com/nvim-lualine/lualine.nvim/pull/621
require("tests.util.helpers")
