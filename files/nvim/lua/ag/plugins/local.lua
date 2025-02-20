-- load any maching-specific plugins
local custom_plugins = vim.fn.environ()["CUSTOM_NVIM_PLUGINS"]
local misc_plugins = {}

if custom_plugins == nil then return misc_plugins end

for _, plugin_dir in ipairs(vim.split(custom_plugins, ",", { trimempty = true })) do
    if vim.fn.isdirectory(plugin_dir) then table.insert(misc_plugins, { dir = plugin_dir, dev = true }) end
end

return misc_plugins
