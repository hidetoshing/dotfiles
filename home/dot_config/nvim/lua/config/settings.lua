-- General Neovim settings

vim.opt.encoding = "utf-8" -- Set default encoding to UTF-8

vim.opt.foldenable = true
vim.opt.foldmethod = "manual"
vim.opt.incsearch = true -- Shows the match while typing

-- Enable auto read and write
vim.opt.autoread = true
vim.opt.autowriteall = true

-- Disable backup and swap files
vim.opt.backup = false
vim.opt.swapfile = false

-- vim.opt.autochdir=true
vim.opt.number = true -- Show line numbers
vim.opt.signcolumn = "yes"

vim.opt.wrap = false

vim.opt.cursorline = true
-- vim.opt.cursorcolumn = true

-- Make backspace behave in a more intuitive way
vim.opt.backspace = { "indent", "eol", "start" }

-- default tab size and indent size
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4

vim.opt.title = true -- Allows neovom to send the Terminal details of the current window, instead of just getting 'v'

-- Enable mouse support in all modes
vim.opt.mouse = "a"

-- setup leader key
vim.g.mapleader = ","

require("config.clipboard").setup()
require("config.selection").setup()
require("config.util").setup()

require("config.gui").setup()

-- Docker Compose 用 LSP が付けられるよう、Compose ファイルだけ専用 filetype に寄せる
vim.filetype.add({
    filename = {
        ["docker-compose.yml"] = "yaml.docker-compose",
        ["docker-compose.yaml"] = "yaml.docker-compose",
        ["compose.yml"] = "yaml.docker-compose",
        ["compose.yaml"] = "yaml.docker-compose",
    },
})
