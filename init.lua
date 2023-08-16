-- tvim runtime path needs to be available from the start
vim.opt.rtp:prepend(os.getenv("TESTNVIM_STATE_DIR"))
-- environment has to be initialized first
require("tvim.env")

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

local logger = require("structlog").get_logger("tvim")
logger:info("Tvim initialized")
