local create_file_or_dir = function ()
    local name = vim.fn.input({
        prompt = "File/directory name: ",
        completion = "dir_in_path",
    })

    local create_dir = function (dirname)
        local success, msg = pcall(vim.fn.mkdir, dirname, "p")
        if not success then
            vim.notify("Failed to create directory: " .. msg, vim.log.levels.ERROR)
        end
        return success
    end

    -- create a new dir if the name ends in '/'
    local is_directory = name:match("%/$") ~= nil
    if is_directory then
        local success = create_dir(name)
        if not success then return end
    else
        local dirname = vim.fs.dirname(name)
        if dirname ~= "." then
            local success = create_dir(dirname)
            if not success then return end
        end
        vim.cmd("!touch " .. name)
    end
end

vim.keymap.set("n", "<C-l>", "<C-w>l", { buffer = true, desc = "Navigate right" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { buffer = true, desc = "Navigate left" })
vim.keymap.set("n", "a", create_file_or_dir, { buffer = true, desc = "Create file or directory" })
