-- colorscheme.lua
-- Specify your colorscheme plugin here



return {
    {
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
        "https://github.com/nvim-tree/nvim-web-devicons",
        lazy = true,
        opts = {},
    },
    {
        "https://github.com/nvim-lualine/lualine.nvim",
        opts = {
            options = {
                theme = "tokyonight",
            },
        },
    },
}