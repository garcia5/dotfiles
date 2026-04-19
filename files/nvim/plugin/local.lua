-- load any machine-specific plugins
local custom_plugins = vim.fn.environ()["CUSTOM_NVIM_PLUGINS"]

if custom_plugins ~= nil then
    for _, plugin_dir in ipairs(vim.split(custom_plugins, ",", { trimempty = true })) do
        if vim.fn.isdirectory(plugin_dir) == 1 then
            vim.pack.add({ { src = plugin_dir, name = vim.fn.fnamemodify(plugin_dir, ":t") } })
        end
    end
end
