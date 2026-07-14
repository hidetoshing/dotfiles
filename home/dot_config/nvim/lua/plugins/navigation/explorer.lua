-- filetree.lua
-- Configure file tree-related plugins for Neovim

return {
    {
        -- neo-tree.nvim plugin
        -- A file explorer tree for Neovim
        "https://github.com/nvim-neo-tree/neo-tree.nvim",
        dependencies = {
            "https://github.com/nvim-lua/plenary.nvim",
            "https://github.com/MunifTanjim/nui.nvim",
            "https://github.com/nvim-tree/nvim-web-devicons", -- optional, but recommended
        },
        cmd = { "Neotree" },
        init = function()
            local reading_stdin = false

            vim.api.nvim_create_autocmd("StdinReadPre", {
                callback = function()
                    reading_stdin = true
                end,
            })

            vim.api.nvim_create_autocmd("VimEnter", {
                once = true,
                callback = function()
                    local temporary_editor_files = {
                        COMMIT_EDITMSG = true,
                        MERGE_MSG = true,
                        SQUASH_MSG = true,
                        TAG_EDITMSG = true,
                        ["git-rebase-todo"] = true,
                    }
                    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")

                    if reading_stdin or vim.o.diff or temporary_editor_files[filename] then
                        return
                    end

                    vim.cmd("Neotree source=filesystem reveal=true position=left")
                end,
            })
        end,
        keys = {
            { "<leader>ee", "<cmd>Neotree source=filesystem reveal=true position=left<CR>", desc = "File Tree" },
            { "<leader>ef", "<cmd>Neotree float<CR>", desc = "Float File Tree" },
            { "<leader>eq", "<cmd>Neotree close<CR>", desc = "Close File Tree" },
            { "<leader>eb", "<cmd>Neotree buffer<CR>", desc = "Buffer Tree" },
            { "<leader>eg", "<cmd>Neotree float git_status<CR>", desc = "Git Status Tree" },
        },
        opts = {
            open_files_using_relative_paths = true,
            close_if_last_window = true,
            filesystem = {
                filtered_items = {
                    visible = true, -- This will show hidden files
                    hide_dotfiles = false,
                    hide_gitignored = true,
                },
                follow_current_file = {
                    enabled = true,
                    leave_dirs_open = false,
                },
            },
        },
    },
}
