-- tasks.lua
-- Configure task runner plugins for Neovim

return {
    {
        "https://github.com/stevearc/overseer.nvim",
        cmd = { "OverseerRun", "OverseerToggle" },
        keys = {
            { "<leader>-", "<CMD>OverseerRun<CR>" },
            { "<leader>_", "<CMD>OverseerToggle<CR>" },
        },
        opts = {},
    },
}
