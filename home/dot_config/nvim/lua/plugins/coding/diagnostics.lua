-- diagnostic.lua
-- Configure diagnostic-related plugins for Neovim

return {
    {
        -- tiny-inline-diagnostic.nvim plugin
        -- A minimal inline diagnostic plugin for Neovim
        "https://github.com/rachartier/tiny-inline-diagnostic.nvim",
        event = "LspAttach",
        opts = {
            options = {
                show_source = {
                    enabled = true,
                },
            },
        },
        config = function(_, opts)
            vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
            require("tiny-inline-diagnostic").setup(opts)
        end,
    },
}
