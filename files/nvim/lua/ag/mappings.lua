-- Mapping helper
---@param mode string
---@param key string
---@param result function | string
---@param desc? string
local mapper = function(mode, key, result, desc) vim.keymap.set(mode, key, result, { noremap = true, silent = true, desc = desc }) end

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
mapper("n", "<C-j>", "<C-w>j", "Window down")
mapper("n", "<C-h>", "<C-w>h", "Window left")
mapper("n", "<C-k>", "<C-w>k", "Window up")
mapper("n", "<C-l>", "<C-w>l", "Window right")
-- Term
mapper("t", "<Esc><Esc>", [[<C-\><C-n>]])
mapper("t", "<C-j>", [[<C-\><C-n><C-w>j]], "Window down")
mapper("t", "<C-h>", [[<C-\><C-n><C-w>h]], "Window left")
mapper("t", "<C-k>", [[<C-\><C-n><C-w>k]], "Window up")
mapper("t", "<C-l>", [[<C-\><C-n><C-w>l]], "Window right")

-- Other basics
mapper("n", "<Down>", [["pdd"pp]], "Move line down")
mapper("n", "<Up>", [["pddk"pP]], "Move line up")
mapper("n", "<C-e>", "3<C-e>") -- scroll down more quickly
mapper("n", "<C-y>", "3<C-y>") -- scroll up more quickly
mapper("n", "<Leader>bn", ":bn<CR>", "Next buffer")
mapper("n", "<Leader>bp", ":bp<CR>", "Prev buffer")
mapper("n", "<Leader>bd", ":bp | bd #<CR>", "Delete current buffer")
mapper("n", "+", "=", "Format")
mapper("n", "<Leader>nn", ":set number!<CR>", "Toggle number")
mapper("n", "<Leader>z", ":call ToggleFocus()<CR>", "Toggle focus")
mapper("n", "<Leader>W", ":set wrap!<CR>", "Toggle wrap")
mapper("i", "<M-r>", [[<Esc>:set paste<CR>i<C-r>"<Esc>:set nopaste<CR>a]], "'set paste' automatically")
mapper("n", "<Leader>tn", "<cmd>tabn<CR>", "Next tab");
mapper("n", "<Leader>tp", "<cmd>tabp<CR>", "Prev tab");
mapper("n", "<Leader>tq", "<cmd>tabcl<CR>", "Close tab");
