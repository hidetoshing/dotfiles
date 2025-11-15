-- treesitter.lua
-- Specify your treesitter plugin here

return {
    {
        'https://github.com/nvim-treesitter/nvim-treesitter', -- treesitter plugin
        lazy = false,
        branch = 'main',
        build = ':TSUpdate', -- command to run after installation
        config = function()
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("vim-treesitter-start", {}),
                callback = function(ctx)
                    -- 必要に応じて`ctx.match`に入っているファイルタイプの値に応じて挙動を制御
                    -- `pcall`でエラーを無視することでパーサーやクエリがあるか気にしなくてすむ
                    pcall(vim.treesitter.start)
                end,
            })
        end,
    },
    {
        'https://github.com/nvim-treesitter/nvim-treesitter-context',
        opts = {},
    },
}