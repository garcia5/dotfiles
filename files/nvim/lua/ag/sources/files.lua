local M = {}

---@type table<string, string[]>
local file_cache = {}
---@type table<string, table<string, string>>
local icon_cache = {}

local function scan_cmd()
    if vim.fn.executable("fd") == 1 then return "fd --type f --exclude '.*' --color never" end
    if vim.fn.isdirectory(".git") == 1 then return "git ls-files" end
    return "find . -type f -not -path '*/.*' | sed 's|^./||'"
end

---Populate the file cache for the given CWD. Safe to call eagerly.
---@param cwd string
local function load_files(cwd)
    local files = vim.fn.systemlist(scan_cmd())
    for i, f in ipairs(files) do
        files[i] = f:gsub("^./", "")
    end
    file_cache[cwd] = files
    icon_cache[cwd] = {}
end

local function invalidate(cwd)
    file_cache[cwd] = nil
    icon_cache[cwd] = nil
end

-- Eagerly populate on startup and CWD change so the first completion is fast.
vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
    group = vim.api.nvim_create_augroup("ag.sources.files", { clear = true }),
    callback = function()
        local cwd = vim.uv.cwd() or vim.fn.getcwd()
        invalidate(cwd)
        vim.schedule(function() load_files(cwd) end)
    end,
})

---Native completion function returning file paths relative to CWD.
---@param findstart integer 1 to find the start of the word, 0 to return matches
---@param base string the text to match against
function M.complete(findstart, base)
    if findstart == 1 then
        local line = vim.fn.getline(".")
        local col = vim.fn.col(".")
        local res = vim.fn.matchstrpos(line:sub(1, col - 1), [=[\f*$]=])
        local start = res[2]
        if start ~= -1 then return start end
        return -3
    end

    local cwd = vim.uv.cwd() or vim.fn.getcwd()
    if not file_cache[cwd] then load_files(cwd) end
    local files = file_cache[cwd]
    local icons = icon_cache[cwd]

    local matches = {}
    local max_w = (vim.o.pummaxwidth > 0 and vim.o.pummaxwidth or 60) - 5
    local has_devicons, devicons = pcall(require, "nvim-web-devicons")

    for _, word in ipairs(files) do
        if base == "" or word:find(base, 1, true) then
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

            local kind = icons[word]
            if not kind then
                kind = "f"
                if has_devicons then
                    local extension = vim.fn.fnamemodify(word, ":e")
                    local icon = devicons.get_icon(word, extension, { default = true })
                    if icon then kind = icon end
                end
                icons[word] = kind
            end

            table.insert(matches, {
                word = word,
                abbr = abbr,
                kind = kind,
                kind_hl = "@string.special.path",
                menu = " path",
            })
        end
    end

    return matches
end

---FZF-lua based completion for files triggered by @
---Positions the picker as a at the bottom of the window using ivy preset theme
function M.fzf_complete()
    local fzf = require("fzf-lua")

    fzf.complete_path({
        "ivy",
        word_pattern = [=[[^%s"'@]*]=],
        winopts = {
            height = 0.40,
            fullscreen = false,
            preview = { hidden = true },
        },
        -- Minimal look
        fzf_opts = {
            ["--multi"] = false,
            ["--ghost"] = "Path",
        },
    })
end

return M
