local source = {}

function source.new(opts)
    local self = setmetatable({}, { __index = source })
    self.opts = opts
    return self
end

function source:get_trigger_characters()
    return { "@" }
end

function source:enabled()
    local bufname = vim.api.nvim_buf_get_name(0)
    local is_prompt = bufname:match("gemini%-edit")
        or bufname:match("%.gemini/tmp/")
        or bufname:match("claude%-")
        or bufname:match("claudecode")

    if not is_prompt then return false end

    local col = vim.api.nvim_win_get_cursor(0)[2]
    local line = vim.api.nvim_get_current_line()
    local char_at_cursor = line:sub(col, col)

    -- If we just typed @, check if it's at start of line or preceded by space
    if char_at_cursor == "@" then
        if col <= 1 then return true end
        local char_before_at = line:sub(col - 1, col - 1)
        return char_before_at:match("%s") ~= nil
    end

    -- If we just typed ., check if we're currently in the middle of an @ file path
    if char_at_cursor == "." then
        local before = line:sub(1, col)
        return before:match("@%S+$") ~= nil
    end

    return false
end

function source:get_completions(ctx, callback)
    local cmd = { "fd", "--type", "f", "--exclude", ".*", "--color", "never" }
    if vim.fn.executable("fd") == 0 then
        cmd = { "git", "ls-files" }
        if vim.fn.isdirectory(".git") == 0 then cmd = { "find", ".", "-type", "f", "-not", "-path", "*/.*" } end
    end

    vim.system(cmd, { text = true }, function(out)
        if out.code ~= 0 then
            callback()
            return
        end
        local lines = vim.split(out.stdout, "\n", { trimempty = true })
        local items = {}
        for _, f in ipairs(lines) do
            f = f:gsub("^./", "")
            table.insert(items, {
                label = "@" .. f,
                insertText = "@" .. f,
                kind = vim.lsp.protocol.CompletionItemKind.File,
            })
        end
        callback({ is_incomplete = false, items = items })
    end)
end

return source
