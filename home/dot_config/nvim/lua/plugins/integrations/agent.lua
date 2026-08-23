local uv = vim.uv or vim.loop

local function load_local_opts()
    local path = vim.fn.stdpath("config") .. "/local/agentic.lua"

    if not uv.fs_stat(path) then
        return {}
    end

    local chunk, load_error = loadfile(path)
    if not chunk then
        vim.notify(("Failed to load local Agentic config %s: %s"):format(path, load_error), vim.log.levels.WARN)
        return {}
    end

    local ok, opts = pcall(chunk)
    if not ok then
        vim.notify(("Failed to evaluate local Agentic config %s: %s"):format(path, opts), vim.log.levels.WARN)
        return {}
    end

    if type(opts) ~= "table" then
        vim.notify(("Local Agentic config %s must return a table"):format(path), vim.log.levels.WARN)
        return {}
    end

    return opts
end

local function build_opts()
    local defaults = {
        -- Any ACP-compatible provider works. Built-in providers include Codex, Claude, OpenCode, and others.
        provider = vim.fn.executable("codex-acp") == 1 and "codex-acp" or "claude-agent-acp",
    }

    return vim.tbl_deep_extend("force", defaults, load_local_opts())
end

return {
    {
        "carlos-algms/agentic.nvim",
        opts = build_opts,
        -- these are just suggested keymaps; customize as desired
        keys = {
            {
                "<leader>At",
                function()
                    require("agentic").toggle()
                end,
                mode = { "n", "v", "i" },
                desc = "Toggle Agentic Chat",
            },
            {
                "<leader>Aa",
                function()
                    require("agentic").add_selection_or_file_to_context()
                end,
                mode = { "n", "v" },
                desc = "Add file or selection to Agentic to Context",
            },
            {
                "<leader>An",
                function()
                    require("agentic").new_session()
                end,
                mode = { "n", "v", "i" },
                desc = "New Agentic Session",
            },
            {
                "<leader>Ar",
                function()
                    require("agentic").restore_session()
                end,
                desc = "Agentic Restore session",
                silent = true,
                mode = { "n", "v", "i" },
            },
            {
                "<leader>Ad", -- ai Diagnostics
                function()
                    require("agentic").add_current_line_diagnostics()
                end,
                desc = "Add current line diagnostic to Agentic",
                mode = { "n" },
            },
            {
                "<leader>AD", -- ai all Diagnostics
                function()
                    require("agentic").add_buffer_diagnostics()
                end,
                desc = "Add all buffer diagnostics to Agentic",
                mode = { "n" },
            },
        },
    },
}
