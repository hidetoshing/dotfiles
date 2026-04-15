-- .config/nvim/lua/config/lazy.lua
-- Configure lazy.nvim plugin manager

local uv = vim.uv or vim.loop

-- Install lazy.nvim if not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not uv.fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

local is_macos = uv.os_uname().sysname == "Darwin"
local spec = {
    -- ui
    { import = "plugins.ui" },

    -- editor
    { import = "plugins.editor" },

    -- coding
    { import = "plugins.coding" },

    -- navigation
    { import = "plugins.navigation" },

    -- git
    { import = "plugins.git" },

    -- automation
    { import = "plugins.automation" },

    -- integrations
    { import = "plugins.integrations.agent" },
}

if is_macos then
    table.insert(spec, { import = "plugins.integrations.obsidian" })
end

-- Configure lazy.nvim
require("lazy").setup({
    spec = spec,
})
