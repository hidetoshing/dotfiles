-- git.lua
-- Configure Git-related plugins for Neovim

return {
    {
        -- gitsigns.nvim plugin
        -- Git integration for buffers in Neovim
        "https://github.com/lewis6991/gitsigns.nvim",
        event = "VeryLazy",
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
    {
        "https://github.com/kdheepak/lazygit.nvim",
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        keys = {
            { "<leader>Gl", "<cmd>LazyGit<cr>", desc = "LazyGit" },
        },
    },
}
