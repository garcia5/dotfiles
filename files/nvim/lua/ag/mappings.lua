-- Mapping helper
---@param mode string
---@param key string
---@param result function | string
local mapper = function(mode, key, result) vim.keymap.set(mode, key, result, { noremap = true, silent = true }) end

-- Essentials
mapper("i", "jj", "<Esc>")
mapper("n", "<Leader>no", ":nohl<CR>")
mapper("n", "<BS>", "daw")
mapper("n", "<CR>", ":e<CR>")
mapper("n", "<Leader><Leader>", "<C-^>")
mapper("n", ":W", ":w")
mapper("n", "I", "0I")

-- Movemint
-- move by line even with `wrap` set
mapper("n", "j", "gj")
mapper("n", "k", "gk")
-- Move between windows
mapper("n", "<C-j>", "<C-w>j")
mapper("n", "<C-h>", "<C-w>h")
mapper("n", "<C-k>", "<C-w>k")
mapper("n", "<C-l>", "<C-w>l")
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
mapper("n", "<Leader>W", ":set wrap!<CR>") -- toggle wrap
mapper("i", "<M-r>", [[<Esc>:set paste<CR>i<C-r>"<Esc>:set nopaste<CR>i]]) -- enable `paste` when I want to paste in insert mode, then disable it again

-- terminal
mapper("n", "<Leader>tn", ":call termcmd#vert()<CR>") -- open new term in vertical split
mapper("n", "<Leader>ts", ":call termcmd#horiz()<CR>") -- open new term in horizontal split

mapper("n", "<Leader>rr", "<cmd>LspRestart<CR>") -- restart language servers
