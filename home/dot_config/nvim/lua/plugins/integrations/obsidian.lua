return {
    {
        "https://github.com/hidetoshing/obsidianus.nvim",
        cmd = { "Obsidian" },
        keys = {
            { "<leader>oo", "<cmd>Obsidian<CR>", desc = "Open Obsidian vault" },
            { "<leader>ot", "<cmd>Obsidian daily<CR>", desc = "Open todays daily-note" },
            { "<leader>on", "<cmd>Obsidian new<CR>", desc = "Create a new note" },
            { "<leader>of", "<cmd>Obsidian find<CR>", desc = "find notes" },
        },
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
        opts = {
            default_vault = "~/Documents/default",
            templates_dir = "templates",
            picker = "telescope",
            notes_subdir = "notes",
        },
    },
    {
        "delphinus/md-render.nvim",
        version = "*",
        dependencies = {
            { "nvim-tree/nvim-web-devicons", version = "*" }, -- optional: file type icons in code blocks
            { "delphinus/budoux.lua", version = "*" }, -- optional: CJK phrase-level line breaking
        },
        keys = {
            { "<leader>mp", "<Plug>(md-render-preview)", desc = "Markdown preview (toggle)" },
            { "<leader>mt", "<Plug>(md-render-preview-tab)", desc = "Markdown preview in tab (toggle)" },
            { "<leader>md", "<Plug>(md-render-demo)", desc = "Markdown render demo" },
        },
    },
}
