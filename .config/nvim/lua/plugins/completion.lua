-- Completion plugin configuration
-- .config/nvim/lua/plugins/completion.lua

return {
    -- blink.cmp plugin
    -- A fast and lightweight completion plugin for Neovim
    'https://github.com/saghen/blink.cmp',
    version = '*',
    dependencies = { 'https://github.com/rafamadriz/friendly-snippets' },
    event = { "InsertEnter", "CmdLineEnter" },

    ---@module 'blink.cmp'
    opts = {
        completion = {
            documentation = {
                window = { border = "rounded" },
                auto_show = true,
                auto_show_delay_ms = 500,
            },
            menu = {
                border = "rounded",
                draw = {
                    treesitter = { 'lsp' },
                    columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 }, { 'source_name' }, },
                },
            },
        },
        signature = {
            enabled = true,
            window = { border = "rounded" },
        },

    },
}
