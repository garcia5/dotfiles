-- Mapping helper
local mapper = function(mode, key, result)
  vim.api.nvim_set_keymap(mode, key, result, {noremap = true, silent = true})
end

-- Essentials
mapper("i", "jj", "<Esc>")
mapper("n", "<Leader>no", ":nohl<CR>")
mapper("n", "<BS>", "daw")
mapper("n", "<CR>", ":e<CR>")
mapper("n", "<Leader><Leader>", "<C-^>")
mapper("n", ":W", ":w")
-- Other basics
mapper("n", "<Leader>nt", ":NvimTreeToggle<CR>")     -- toggle file browser in left split
mapper("n", "<Leader>nf", ":NvimTreeFindFile<CR>")   -- open file browser in left split with the current file focused
mapper("n", "<Leader>z" , ":call ToggleFocus()<CR>") -- toggle focus on current window
mapper("n", "<Leader>tn", ":vs | term<CR>")          -- open new term in vertical split
mapper("n", "<Leader>ts", ":sp | term<CR>")          -- open new term in horizontal split
mapper("n", "<Leader>bd", ":bp | bd #<CR>")          -- delete the current buffer
mapper("n", "Y"         , "y$")                      -- yank to the end of the line (like D or C)
mapper("n", "n"         , "nzz")                     -- center jumping to next match
mapper("n", "N"         , "Nzz")                     -- center jumping to prev match
mapper("n", "<Down>"    , [["pdd"pp]])               -- move line down
mapper("n", "<Up>"      , [["pddk"pP]])              -- move line up
mapper("n", "<C-e>"     , "3<C-e>")                  -- scroll down more quickly
mapper("n", "<C-y>"     , "3<C-y>")                  -- scroll up more quickly
mapper("n", "<Leader>bn", ":bn<CR>")                 -- next buffer
mapper("n", "<Leader>bp", ":bp<CR>")                 -- prev buffer

-- Commenting
mapper("n", "<Leader>ci", "gcc")
mapper("v", "<Leader>ci", "gc")

-- Telescope integration
mapper("n", "<Leader>ff", "<cmd>lua require'ag.telescope'.builtin('find_files')<CR>")                -- search all files, respecting .gitignore if one exists
mapper("n", "<Leader>fb", "<cmd>lua require'ag.telescope'.builtin('buffers')<CR>")                   -- search open buffers
mapper("n", "<Leader>fl", "<cmd>lua require'ag.telescope'.builtin('current_buffer_fuzzy_find')<CR>") -- search lines in current buffer
mapper("n", "<Leader>gg", "<cmd>lua require'ag.telescope'.builtin('live_grep')<CR>")                 -- search all lines in project
mapper("n", "<Leader>fr", "<cmd>lua require'ag.telescope'.builtin('lsp_references')<CR>")            -- search references to symbol under cursor
mapper("n", "<Leader>co", "<cmd>lua require'ag.telescope'.builtin('colorscheme')<CR>")               -- colorschemes
mapper("n", "<Leader>gc", "<cmd>lua require'ag.telescope'.builtin('git_branches')<CR>")              -- checkout different branches
mapper("n", "<Leader>re", "<cmd>lua require'ag.telescope'.builtin('git_commits')<CR>")               -- checkout commits; <CR> to checkout, <C-r>[m, s, h] to reset [mixed, soft, hard]
mapper("n", "<Leader>qf", "<cmd>lua require'ag.telescope'.builtin('quickfix')<CR>")                  -- jump to items in quickfix list
mapper("n", "<Leader>do", "<cmd>Dash<CR>")

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
mapper("t", "<C-j>",      [[<C-\><C-n><C-w>j]])
mapper("t", "<C-h>",      [[<C-\><C-n><C-w>h]])
mapper("t", "<C-k>",      [[<C-\><C-n><C-w>k]])
mapper("t", "<C-l>",      [[<C-\><C-n><C-w>l]])

-- Git things
mapper("n", "<Leader>gs", ":tab Git<CR>")                   -- `git status` in a new tab to save screen real estate
mapper("n", "<Leader>gd", "<cmd>Gdiffsplit<CR>")            -- open a split diffing the current file
mapper("n", "<Leader>gp", "<cmd>Git pull<CR>")              -- pull
mapper("n", "<Leader>rh", "<cmd>Gitsigns reset_hunk<CR>")   -- reset hunk under cursor
mapper("n", "<Leader>gn", "<cmd>Gitsigns next_hunk<CR>zz")  -- move to next hunk and center it
mapper("n", "<Leader>gp", "<cmd>Gitsigns prev_hunk<CR>zz")  -- move to prev hunk and center it
mapper("n", "="         , "<cmd>Gitsigns preview_hunk<CR>") -- diff of hunk under cursor

-- DAP
mapper("n", "<C-g>", "<cmd>lua require('ag.debug').start_with_ui()<CR>")  -- start/resume debugging
mapper("n", "<C-b>", "<cmd>lua require('dap').toggle_breakpoint()<CR>")
mapper("n", "<C-s>", "<cmd>lua require('dap').step_into()<CR>")
mapper("n", "<C-d>", "<cmd>lua require('dap').step_over()<CR>")
mapper("n", "<C-p>", "<cmd>lua require('dap').repl.open()<CR>")
mapper("n", "<C-i>", "<cmd>lua require('dapui').float_element('scopes')<CR>")
mapper("n", "<Leader>dc", "<cmd>lua require('dapui').toggle()<CR>")
