-- Define lualine_helper module
local M = {
    config = {
        lsp_icon = " ",
    }
}

M.lsp_clients = function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if next(clients) == nil then return " none" end

    local client_names = {}
    for _, client in pairs(clients) do
        if (client.name == "null-ls") then
            local sources = {}
            for _, source in ipairs(require("null-ls.sources").get_available(vim.bo.filetype)) do
                table.insert(sources, source.name)
            end
            table.insert(client_names, "null-ls(" .. table.concat(sources, ", ") .. ")")
        else
            table.insert(client_names, client.name)
        end
    end
    return lualine_helper.config.lsp_icon .. table.concat(client_names, ", ")
end

M.current_time = function()
    return os.date("%H:%M") -- 時:分の形式で現在時刻を取得
end

M.setup = function(args)
    M.config = vim.tbl_deep_extend("force", M.config, args or {})
end

return M

