-- Basic global formatting options
vim.opt.textwidth = 80         -- Wrap here

vim.opt.formatoptions:remove({
    't',                       -- Don't auto wrap text
    'o',                       -- Do not continue comments with 'o' or 'O'
    '2',                       -- ... that's just weird
})
vim.opt.formatoptions:append({
    'r',                       -- Continue comments with <Enter>
    'n',                       -- Allow formatting lists
})

-- format.nvim configuration
--[[
require'format'.setup({
    ['*'] = {
        {cmd = {"sed -Ei 's/[ \t]*$//'"}},
    },
    -- TODO: these do things differently than the pre-commit hooks, figure out
    -- why
    --
    --python = {
    --    {cmd = {"autopep8 --in-place"}},
    --},
    --typescript = {
    --    {cmd = {"prettier --write", "eslint --fix"}},
    --},
    --javascript = {
    --    {cmd = {"prettier --write", "eslint --fix"}},
    --},
    --vue = {
    --    {cmd = {"prettier --write", "eslint --fix"}},
    --},
})
--]]
