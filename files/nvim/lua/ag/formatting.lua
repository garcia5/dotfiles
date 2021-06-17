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

vim.opt.autoindent  = true     -- continue indentation to new line
vim.opt.smarttab    = true     -- <Tab> behaves as expected
vim.opt.expandtab   = true     -- <Tab> inserts 4 spaces
vim.opt.shiftwidth  = 4        -- >>, << use 4 spaces
vim.opt.tabstop     = 4        -- <Tab> appears as 4 spaces
vim.opt.softtabstop = 4        -- <Tab> behaves as 4 spaces

-- format.nvim configuration
require'format'.setup {
    python = {
        {cmd={"yapf -i --exclude **/mock*.py"}},
    },
    typescript = {
        {cmd={[[sed -Ei 's/[  ]+$//']]}},
    },
}
