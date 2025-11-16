-- lsp.lua
-- Specify your LSP plugin here

return {
    {
        "https://github.com/lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {},
    },
    {
        -- gitlinker.nvim plugin
        -- Generate shareable Git repository links for code
        "https://github.com/linrongbin16/gitlinker.nvim",
        cmd = "GitLink",
        keys = {
            { "<leader>Gy", "<cmd>GitLink<CR>", mode = { "n", "v" }, desc = "Yank git link" },
            { "<leader>Gx", "<cmd>GitLink!<CR>", mode = { "n", "v" }, desc = "Open git link" },
        },
        opts = {},
    },
}