-- lsp.lua
-- Specify your LSP plugin here

return {
    {
        --  nvim-lspconfig plugin
        --  Configurations for Neovim's built-in LSP client
        'https://github.com/neovim/nvim-lspconfig',
        event = { "BufReadPre", "BufNewFile" },
    },
    {
        -- nvim-lsp-notify plugin
        -- Notify LSP progress and messages in Neovim
        "https://github.com/mrded/nvim-lsp-notify",
        event = { "BufReadPre", "BufNewFile" },
    },
    {
        -- hlchunk.nvim plugin
        -- Highlight code chunks based on indentation
        "https://github.com/shellRaining/hlchunk.nvim",
        event = { "BufReadPre", "BufNewFile" },
    },
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        lazy = true,
        config = function()
            require("tiny-inline-diagnostic").setup()
            vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
        end,
    },
    {
        -- glance.nvim plugin
        -- A code peek and definition viewer for Neovim
        "https://github.com/dnlhc/glance.nvim",
        cmd = 'Glance',
        keys = {
            { "<leader>wd", "<cmd>Glance definitions<CR>", desc = "Glance Definitions" },
            { "<leader>wr", "<cmd>Glance references<CR>", desc = "Glance References" },
            { "<leader>wt", "<cmd>Glance type_definitions<CR>", desc = "Glance Type Definitions" },
            { "<leader>wi", "<cmd>Glance implementations<CR>", desc = "Glance Implementations" },
        },
    },
    -- {
    --    -- copilot.vim plugin
    --    -- GitHub Copilot integration for Neovim
    --    "https://github.com/github/copilot.vim",
    --    event = "VeryLazy",
    -- },
}