-- Mapping helper
local mapper = function(mode, key, result)
  vim.api.nvim_set_keymap(mode, key, result, {noremap = true, silent = true})
end

-- Essentials
mapper("i", "jj", "<Esc>")
mapper("n", "<Leader>no", ":nohl<CR>")

-- FZF integration
mapper("n", "<Leader>ff", "<cmd>:Files<CR>")         -- search all files, respecting .gitignore if one exists
mapper("n", "<Leader>fb", "<cmd>:Buffers<CR>")       -- search open buffers
mapper("n", "<Leader>fl", "<cmd>:Lines<CR>")         -- search lines in open buffers
mapper("n", "<Leader>gg", "<cmd>:Rg<CR>")            -- search all lines in project
mapper("n", "<Leader>fr", "<cmd>:References<CR>")    -- search references to symbol under cursor
mapper("n", "<Leader>co", "<cmd>:Colors<CR>")        -- Fuzzy find colorschemes

mapper("n", "<Leader>nt", ":call ToggleNetrw()<CR>") -- Toggle netrw

mapper("n", "<Leader>z", ":call ToggleFocus()<CR>")  -- Toggle focus

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
mapper("t", "<Esc><Esc>",[[<C-\><C-n>]])
mapper("t", "<C-j>",     [[<C-\><C-n><C-w>j]])
mapper("t", "<C-h>",     [[<C-\><C-n><C-w>h]])
mapper("t", "<C-k>",     [[<C-\><C-n><C-w>k]])
mapper("t", "<C-l>",     [[<C-\><C-n><C-w>l]])

mapper("n", "<Leader>tn", ":vs | term<CR>") -- open new term in vertical split

-- Fugitive
mapper("n", "<Leader>gs", "<cmd>:Gstatus<CR>")
mapper("n", "<Leader>gd", "<cmd>:Gdiffsplit<CR>")
mapper("n", "<Leader>gb", "<cmd>:Gblame<CR>")
mapper("n", "<Leader>gc", "<cmd>:Gcommit<CR>")
mapper("n", "<Leader>gp", "<cmd>:Gpush<CR>")
mapper("n", "<Leader>gP", "<cmd>:Gpull<CR>")
