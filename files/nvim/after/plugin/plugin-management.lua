vim.api.nvim_create_user_command("Psync", function()
    vim.pack.update()
    local unused = vim.iter(vim.pack.get())
        :filter(function(x) return not x.active end)
        :map(function(x) return x.spec.name end)
        :totable()
    if #unused > 0 then vim.pack.del(unused) end
end, { desc = "Update plugins" })
