-- Mapping helper
local mapper = function(mode, key, result)
  vim.api.nvim_set_keymap(mode, key, result, {noremap = true, silent = true})
end

-- Essentials
mapper("i", "jj", "<Esc>")
mapper("n", "<Leader>no", ":nohl<CR>")
mapper("n", "<BS>", "daw")
mapper("n", "<CR>", ":e<CR>")
-- Other basics
mapper("n" , "<Leader>nt" , ":call ToggleNetrw()<CR>") -- toggle netrw
mapper("n" , "<Leader>z"  , ":call ToggleFocus()<CR>") -- toggle focus
mapper("n" , "<Leader>tn" , ":vs | term<CR>")          -- open new term in vertical split
mapper("n" , "<Leader>bd" , ":bp | bd #<CR>")          -- delete the current buffer
-- get into dotfile editing mode
mapper("n" , "<Leader><Leader>v", ":cd ~/dotfiles/files/<CR>'V")

-- Telescope integration
mapper("n", "<Leader>ff", "<cmd>lua require'telescope.builtin'.find_files{}<CR>")                -- search all files, respecting .gitignore if one exists
mapper("n", "<Leader>fb", "<cmd>lua require'telescope.builtin'.buffers{}<CR>")                   -- search open buffers
mapper("n", "<Leader>fl", "<cmd>lua require'telescope.builtin'.current_buffer_fuzzy_find{}<CR>") -- search lines in current buffer
mapper("n", "<Leader>gg", "<cmd>lua require'telescope.builtin'.live_grep{}<CR>")                 -- search all lines in project
mapper("n", "<Leader>fr", "<cmd>lua require'telescope.builtin'.lsp_references{}<CR>")            -- search references to symbol under cursor
mapper("n", "<Leader>co", "<cmd>lua require'telescope.builtin'.colorscheme{}<CR>")               -- colorschemes
mapper("n", "<Leader>cd", "<cmd>lua require'telescope.builtin'.commands{}<CR>")                  -- command history
mapper("n", "<Leader>gc", "<cmd>lua require'telescope.builtin'.git_branches{}<CR>")              -- checkout different branches

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
-- Move between open buffers
-- 'noremap' breaks these mappings because of ins-copmleteion defaults
-- (probably)
vim.api.nvim_set_keymap("n", "<C-n>", "<Plug>AirlineSelectNextTab", {silent = true})
vim.api.nvim_set_keymap("n", "<C-p>", "<Plug>AirlineSelectPrevTab", {silent = true})
-- Term
mapper("t", "<Esc><Esc>",[[<C-\><C-n>]])
mapper("t", "<C-j>",     [[<C-\><C-n><C-w>j]])
mapper("t", "<C-h>",     [[<C-\><C-n><C-w>h]])
mapper("t", "<C-k>",     [[<C-\><C-n><C-w>k]])
mapper("t", "<C-l>",     [[<C-\><C-n><C-w>l]])

-- Fugitive/Git
mapper("n" , "<Leader>gs" , "<cmd>Git<CR>")
mapper("n" , "<Leader>gd" , "<cmd>Gdiffsplit<CR>")
mapper("n" , "<Leader>gp" , "<cmd>Git pull<CR>")
