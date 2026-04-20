local M = {}

---Native completion function for files triggered by @
---@param findstart integer 1 to find the start of the word, 0 to return matches
---@param base string the text to match against
function M.complete(findstart, base)
    if findstart == 1 then
        local line = vim.fn.getline(".")
        local col = vim.fn.col(".")
        -- Find the start of the word including the @ sign
        local res = vim.fn.matchstrpos(line:sub(1, col - 1), [=[@\k*$]=])
        local start = res[2]
        if start ~= -1 then return start end
        return -3
    end

    -- Get the full list of files
    local cmd = "fd --type f --exclude '.*' --color never"
    if vim.fn.executable("fd") == 0 then
        if vim.fn.isdirectory(".git") == 1 then
            cmd = "git ls-files"
        else
            cmd = "find . -type f -not -path '*/.*' | sed 's|^./||'"
        end
    end

    local files = vim.fn.systemlist(cmd)
    local matches = {}
    local max_w = vim.o.pummaxwidth - 5 -- leave room for kind icon and padding

    local has_devicons, devicons = pcall(require, "nvim-web-devicons")

    for _, f in ipairs(files) do
        local word = "@" .. f:gsub("^./", "")
        local abbr = word

        -- Respect pummaxwidth by truncating the middle of long paths
        if max_w > 0 and #abbr > max_w then
            local prefix_len = 15
            local suffix_len = max_w - prefix_len - 3 -- -3 for "..."
            if suffix_len > 0 then
                abbr = abbr:sub(1, prefix_len) .. "..." .. abbr:sub(-suffix_len)
            else
                abbr = abbr:sub(1, max_w - 3) .. "..."
            end
        end

        local kind = "f"
        if has_devicons then
            local extension = vim.fn.fnamemodify(f, ":e")
            local icon = devicons.get_icon(f, extension, { default = true })
            if icon then kind = icon end
        end

        table.insert(matches, {
            word = word,
            abbr = abbr,
            kind = kind,
        })
    end

    return matches
end

return M
