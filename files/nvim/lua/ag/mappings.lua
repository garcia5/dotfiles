-- Mapping helper
---@param mode string
---@param key string
---@param result function | string
local mapper = function(mode, key, result) vim.keymap.set(mode, key, result, { noremap = true, silent = true }) end
local no_plugins = require("ag.plugins")

-- Essentials
mapper("i", "jj", "<Esc>")
mapper("n", "<Leader>no", ":nohl<CR>")
mapper("n", "<BS>", "daw")
mapper("n", "<CR>", ":e<CR>")
mapper("n", "<Leader><Leader>", "<C-^>")
mapper("n", ":W", ":w")
mapper("n", "I", "0I")

-- Movemint
mapper("n", "<C-j>", "<C-w>j")
mapper("n", "<C-h>", "<C-w>h")
mapper("n", "<C-k>", "<C-w>k")
mapper("n", "<C-l>", "<C-w>l")
-- Move without firing 'BufEnter' autocommands
mapper("n", "<M-j>", ":noautocmd wincmd j<CR>")
mapper("n", "<M-h>", ":noautocmd wincmd h<CR>")
mapper("n", "<M-k>", ":noautocmd wincmd k<CR>")
mapper("n", "<M-l>", ":noautocmd wincmd l<CR>")
-- Term
mapper("t", "<Esc><Esc>", [[<C-\><C-n>]])
mapper("t", "<C-j>", [[<C-\><C-n><C-w>j]])
mapper("t", "<C-h>", [[<C-\><C-n><C-w>h]])
mapper("t", "<C-k>", [[<C-\><C-n><C-w>k]])
mapper("t", "<C-l>", [[<C-\><C-n><C-w>l]])

-- Other basics
mapper("n", "<Down>", [["pdd"pp]]) -- move line down
mapper("n", "<Up>", [["pddk"pP]]) -- move line up
mapper("n", "<C-e>", "3<C-e>") -- scroll down more quickly
mapper("n", "<C-y>", "3<C-y>") -- scroll up more quickly
mapper("n", "<Leader>bn", ":bn<CR>") -- next buffer
mapper("n", "<Leader>bp", ":bp<CR>") -- prev buffer
mapper("n", "<Leader>bd", ":bp | bd #<CR>") -- delete the current buffer
mapper("n", "+", "=") -- new format mapping
mapper("n", "<Leader>nn", ":set number!<CR>") -- toggle line numbers
mapper("n", "<Leader>z", ":call ToggleFocus()<CR>") -- toggle focus on current window

-- terminal
mapper("n", "<Leader>tn", ":call termcmd#vert()<CR>") -- open new term in vertical split
mapper("n", "<Leader>ts", ":call termcmd#horiz()<CR>") -- open new term in horizontal split

mapper("n", "<Leader>rr", "<cmd>lua vim.lsp.stop_client(vim.lsp.get_active_clients())<CR>") -- start language servers
