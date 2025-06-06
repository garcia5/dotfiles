-- Fix weird indentation behavior: always add 1 indent to line after open paren
vim.g.pyindent_nested_paren = vim.fn.shiftwidth()
vim.g.pyindent_open_paren = vim.fn.shiftwidth()
