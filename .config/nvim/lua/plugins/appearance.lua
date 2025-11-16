-- Appearance plugins configuration
-- .config/nvim/lua/plugins/appiarance.lua
-- Configure appearance-related plugins

return {
    {
        -- nvim-notify plugin
        -- A fancy notification manager for Neovim
        "https://github.com/rcarriga/nvim-notify",
        config = function(_, opts)
            local notify = require("notify")
            notify.setup(opts)
            vim.notify = notify
        end,
    },
    {
        -- lualine.nvim plugin
        -- A blazing fast and easy to configure Neovim statusline
        "https://github.com/nvim-lualine/lualine.nvim",
        opts = {
            options = {
                theme = "tokyonight-night",
            },
            sections = {
                lualine_c = {'filename', 'aerial' },
                lualine_x = {
                    'encoding',
                    'fileformat',
                    'filetype',
                    "require'config.helper_lualine'.lsp_clients()"
                },
                lualine_z = {
                    'location',
                    "require'config.helper_lualine'.current_time()"
                },
            }
        },
    },
    {
        -- bufferline.nvim plugin
        -- A snazzy buffer line (with tabpage integration) for Neovim
        'https://github.com/akinsho/bufferline.nvim',
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {'nvim-tree/nvim-web-devicons', },
        opts = {},
    },
    {
        -- nvim-web-devicons plugin
        -- File type icons for Neovim
        "https://github.com/nvim-tree/nvim-web-devicons",
        lazy = true,
        opts = {},
    },
}