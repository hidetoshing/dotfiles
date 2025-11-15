-- Appearance plugins configuration
-- .config/nvim/lua/plugins/appiarance.lua
-- Configure appearance-related plugins

return {
    {
        -- tokyonight.nvim plugin
        -- A stylish and modern color scheme for Neovim
        "https://github.com/folke/tokyonight.nvim",
        lazy = false,
        opts = {
            style = "night",
        },
        config = function()
            vim.cmd.colorscheme("tokyonight")
        end,
    },
    {
        -- nvim-web-devicons plugin
        -- File type icons for Neovim
        "https://github.com/nvim-tree/nvim-web-devicons",
        lazy = true,
        opts = {},
    },
    {
        -- lualine.nvim plugin
        -- A blazing fast and easy to configure Neovim statusline
        "https://github.com/nvim-lualine/lualine.nvim",
        opts = {
            options = {
                theme = "tokyonight",
            },
        },
    },
    {
        -- nvim-notify plugin
        -- A fancy notification manager for Neovim
        "https://github.com/rcarriga/nvim-notify",
        lazy = true,
    },
}