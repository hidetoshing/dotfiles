-- navigation.lua
-- Configure code navigation plugins for Neovim

return {
    {
        -- glance.nvim plugin
        -- A code peek and definition viewer for Neovim
        "https://github.com/dnlhc/glance.nvim",
        cmd = "Glance",
        keys = {
            { "<leader>gd", "<cmd>Glance definitions<CR>", desc = "Glance Definitions" },
            { "<leader>gr", "<cmd>Glance references<CR>", desc = "Glance References" },
            { "<leader>gt", "<cmd>Glance type_definitions<CR>", desc = "Glance Type Definitions" },
            { "<leader>gi", "<cmd>Glance implementations<CR>", desc = "Glance Implementations" },
        },
        opts = {
            border = {
                enable = true, -- Show window borders. Only horizontal borders allowed
            },
        },
    },
    {
        -- aerial.nvim plugin
        -- A code outline window for Neovim
        "https://github.com/stevearc/aerial.nvim",
        dependencies = {
            "https://github.com/nvim-telescope/telescope.nvim",
        },
        cmd = {
            "AerialOpen",
            "AerialClose",
            "AerialToggle",
            "AerialFocus",
            "AerialNavOpen",
            "AerialNavToggle",
            "AerialInfo",
        },
        keys = {
            { "<leader>to", "<cmd>AerialOpen<cr>", desc = "toggle Aerial" },
            { "<leader>tf", "<cmd>AerialFocus<cr>", desc = "focus Aerial" },
        },
        opts = {
            attach_mode = "global",
            backends = { "treesitter", "lsp", "markdown", "asciidoc", "man" },
            show_guides = true,
        },
        config = function(_, opts)
            require("aerial").setup(opts)
            require("telescope").load_extension("aerial")
        end,
    },
}
