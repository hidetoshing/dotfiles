-- structure.lua
-- Configure structure and editing helper plugins for Neovim

return {
    {
        -- hlchunk.nvim plugin
        -- Highlight code chunks based on indentation
        "https://github.com/shellRaining/hlchunk.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            chunk = {
                enable = true,
                use_treesitter = true,
                notify = false,
                style = { { fg = "#444488" }, { fg = "#c21f30" } },
            },
        },
    },
    {
        "https://github.com/kylechui/nvim-surround",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end,
    },
}
