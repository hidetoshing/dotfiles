-- telescope.lua
-- Specify your telescope plugin here

-- keys telescope setting
    -- f for files / find
    -- g for git / github
    -- b for buffers
    -- r for ripgrep
    -- q for quickfix
    -- l for lsp
    -- t for treesitter

return {
    {
        "https://github.com/nvim-telescope/telescope.nvim",
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find Files" },
            { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help Tags" },
            { "leader>f:", "<cmd>Telescope commands<CR>", desc = "Commands" },
            { "leader>f?", "<cmd>Telescope keymaps<CR>", desc = "Keymaps" },
            { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Old Files" },

            { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
            { "<leader>bb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },

            { "<leader>rg", "<cmd>Telescope live_grep<CR>", desc = "Live Grep" },

            { "<leader>qq", "<cmd>Telescope quickfix<CR>", desc = "Quickfix" },

            { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Git Commits" },
            { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Git Status" },
            { "<leader>gb", "<cmd>Telescope git_branches<CR>", desc = "Git Branches" },

            { "<leader>lr", "<cmd>Telescope lsp_references<CR>", desc = "LSP References" },
            { "<leader>ld", "<cmd>Telescope lsp_definitions<CR>", desc = "LSP Definitions" },
            { "<leader>li", "<cmd>Telescope lsp_implementations<CR>", desc = "LSP Implementations" },

            { "<leader>ts", "<cmd>Telescope treesitter<CR>", desc = "Treesitter Symbols" },

            -- resume last telescope
            { "<leader>.", "<cmd>Telescope resume<CR>", desc = "Resume" },
        },
        cmd = { "Telescope" },
    },
    {
        "https://github.com/nvim-lua/plenary.nvim",
        lazy = true,
    },
    {
        "https://github.com/nvim-telescope/telescope-file-browser.nvim",
        -- dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>fe", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>", desc = "File Browser" },
        },
        opts = {
            hijack_netrw = true,
            hidden = { file_browser = true, folder_browser = true },
        },
        config = function(_, opts)
            require("telescope").load_extension("file_browser")
        end,
    },
    {
        "https://github.com/nvim-telescope/telescope-ghq.nvim",
        keys = {
            { "<leader>gh", "<cmd>Telescope ghq list<CR>", desc = "Ghq List" },
        },
        config = function(_, opts)
            require("telescope").load_extension("ghq")
        end,
    },
}
