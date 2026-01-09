-- Fix weird indentation behavior: always add 1 indent to line after open paren
vim.g.pyindent_nested_paren = vim.fn.shiftwidth()
vim.g.pyindent_open_paren = vim.fn.shiftwidth()

local venv_path = require("ag.utils").get_python_venv_path()
if venv_path ~= nil then vim.env["PATH"] = vim.fs.joinpath(venv_path, "bin") .. ":" .. vim.env["PATH"] end

-- Helper to fold docstrings
local function fold_docstrings()
    -- Use treesitter folding as base
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo.foldenable = true

    local parser = vim.treesitter.get_parser(0)
    local tree = parser:parse()[1]
    local root = tree:root()

    if vim.b[0].docstrings_folded == nil then vim.b[0].docstrings_folded = false end

    -- Query for Python docstrings
    local query = vim.treesitter.query.parse(
        "python",
        [[
        (expression_statement
          (string) @docstring)
        ]]
    )

    if vim.b[0].docstrings_folded then
        -- When unfolding, just refresh to use treesitter folds
        vim.cmd("normal! zx")
    else
        -- First, let treesitter create its folds
        vim.cmd("normal! zx")

        -- Then handle docstring folds
        for _, node in query:iter_captures(root, 0) do
            local start_row, _, end_row, _ = node:range()
            local start_line = start_row + 1
            local end_line = end_row + 1

            -- Only try to fold if it's a multi-line docstring
            if end_line > start_line then
                -- Check if a fold exists at this line
                local fold_level = vim.fn.foldlevel(start_line)
                if fold_level == 0 then
                    -- No fold exists, create a manual fold for this docstring
                    vim.cmd(string.format("%d,%dfold", start_line, end_line))
                end

                -- Close the fold at the specific line number
                pcall(function() vim.cmd(string.format("%dfoldclose", start_line)) end)
            end
        end
    end

    vim.b[0].docstrings_folded = not vim.b[0].docstrings_folded
end

vim.keymap.set(
    "n",
    "zd",
    fold_docstrings,
    { buffer = true, silent = true, noremap = true, desc = "Fold python docstrings" }
)
