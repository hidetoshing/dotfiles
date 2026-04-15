-- lsp.lua
-- Specify your LSP plugin here

local representative_servers = {
    "autotools_ls",
    "bashls",
    "copilot",
    "docker_compose_language_service",
    "dockerls",
    -- "gopls",
    "html",
    "lua_ls",
    "marksman",
    "pyright",
    "rust_analyzer",
    "vtsls",
    "vue_ls",
}

return {
    {
        -- mason.nvim plugin
        -- Manage external LSP servers, DAP servers, linters, and formatters
        "https://github.com/mason-org/mason.nvim",
        build = ":MasonUpdate",
        cmd = { "Mason", "MasonUpdate", "MasonLog", "MasonInstall", "MasonUninstall", "MasonUninstallAll" },
        config = true,
    },
    {
        -- mason-lspconfig.nvim plugin
        -- Bridge between mason.nvim and nvim-lspconfig
        "https://github.com/mason-org/mason-lspconfig.nvim",
        dependencies = {
            { "mason-org/mason.nvim" },
            { "neovim/nvim-lspconfig" },
        },
        event = "VeryLazy",
        opts = {
            ensure_installed = representative_servers,
            automatic_enable = representative_servers,
        },
        keys = {
            { "gh", "<cmd>lua vim.lsp.buf.hover()       <CR>" },
            { "gd", "<cmd>lua vim.lsp.buf.definition()  <CR>" },
            { "gD", "<cmd>lua vim.lsp.buf.declaration() <CR>" },
        },
        config = function(_, opts)
            local ok, blink = pcall(require, "blink.cmp")
            if ok then
                vim.lsp.config("*", {
                    capabilities = blink.get_lsp_capabilities(),
                })
            end

            require("mason-lspconfig").setup(opts)
        end,
    },
    {
        -- nvim-lsp-notify plugin
        -- Notify LSP progress and messages in Neovim
        "https://github.com/mrded/nvim-lsp-notify",
        event = { "BufReadPre", "BufNewFile" },
        opt = {},
    },
}
