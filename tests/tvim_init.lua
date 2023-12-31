vim.opt.rtp:prepend(os.getenv("TESTNVIM_STATE_DIR"))
-- environment has to be initialized first
require("tvim.env")
-- tvim runtime path needs to be available from the start

vim.opt.rtp:append(vim.fn.stdpath("plenary"))
vim.opt.rtp:append(vim.fn.stdpath("structlog"))

local bootstrap = require("tvim.bootstrap")
vim.opt.rtp = bootstrap.bootstrap()

bootstrap.load_user_conf()
bootstrap.init()

bootstrap.process_user_config()

vim.opt.termguicolors = true
bootstrap.load_structlog()
-- NOTE: careful about name collisions
-- see https://github.com/nvim-lualine/lualine.nvim/pull/621
require("tests.util.helpers")
