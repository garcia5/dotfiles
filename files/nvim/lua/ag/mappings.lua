-- Mapping helper
local mapper = function(mode, key, result)
  vim.api.nvim_set_keymap(mode, key, result, {noremap = true, silent = true})
end

-- Essentials
mapper("i", "jj", "<Esc>")
mapper("n", "<Leader>no", ":nohl<CR>")

-- FZF integration
-- search all files, respecting .gitignore if one exists
mapper("n", "<Leader>ff", "<cmd>:Files<CR>")
-- search open buffers
mapper("n", "<Leader>fb", "<cmd>:Buffers<CR>")
-- search lines in open buffers
mapper("n", "<Leader>fl", "<cmd>:Lines<CR>")
-- search all lines in project
mapper("n", "<Leader>gg", "<cmd>:Rg<CR>")
-- Fuzzy find colorschemes
mapper("n", "<Leader>co", "<cmd>:Colors<CR>")

-- Toggle netrw
mapper("n", "<Leader>nt", ":call ToggleNetrw()<CR>")

-- Toggle focus
mapper("n", "<Leader>z", ":call ToggleFocus()<CR>")

-- Movemint
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
-- open new term in vertical split
mapper("n", "<Leader>tn", ":vnew<CR><C-w><C-l>:term<CR>")

-- Fugitive
mapper("n", "<Leader>gs", "<cmd>:Gstatus<CR>")
mapper("n", "<Leader>gd", "<cmd>:Gdiffsplit<CR>")
mapper("n", "<Leader>gb", "<cmd>:Gblame<CR>")
mapper("n", "<Leader>gc", "<cmd>:Gcommit<CR>")
mapper("n", "<Leader>gp", "<cmd>:Gpush<CR>")
mapper("n", "<Leader>gP", "<cmd>:Gpull<CR>")
