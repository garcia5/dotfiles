-- Mapping helper
local mapper = function(mode, key, result)
    vim.keymap.set(mode, key, result, { noremap = true, silent = true })
end

-- Essentials
mapper("i", "jj", "<Esc>")
mapper("n", "<Leader>no", ":nohl<CR>")
mapper("n", "<BS>", "daw")
mapper("n", "<CR>", ":e<CR>")
mapper("n", "<Leader><Leader>", "<C-^>")
mapper("n", ":W", ":w")

-- Other basics
mapper("n", "<Leader>nt", ":NvimTreeToggle<CR>") -- toggle file browser in left split
mapper("n", "<Leader>nf", ":NvimTreeFindFile<CR>") -- open file browser in left split with the current file focused
mapper("n", "<Leader>nr", ":NvimTreeRefresh<CR>") -- refresh file browser contents
mapper("n", "<Leader>z", ":call ToggleFocus()<CR>") -- toggle focus on current window
mapper("n", "<Leader>tn", ":call termcmd#vert()<CR>") -- open new term in vertical split
mapper("n", "<Leader>ts", ":call termcmd#horiz()<CR>") -- open new term in horizontal split
mapper("n", "<Leader>bd", ":bp | bd #<CR>") -- delete the current buffer
mapper("n", "<Down>", [["pdd"pp]]) -- move line down
mapper("n", "<Up>", [["pddk"pP]]) -- move line up
mapper("n", "<C-e>", "3<C-e>") -- scroll down more quickly
mapper("n", "<C-y>", "3<C-y>") -- scroll up more quickly
mapper("n", "<Leader>bn", ":bn<CR>") -- next buffer
mapper("n", "<Leader>bp", ":bp<CR>") -- prev buffer
mapper("n", "+", "=") -- new format mapping
mapper("n", "<Leader>nn", ":set number!<CR>") -- toggle line numbers
mapper("n", "<Leader>ou", "<cmd>AerialToggle!<CR>") -- toggle code outline, powered by tree-sitter
mapper("n", "<Leader>rr", "<cmd>lua vim.lsp.stop_client(vim.lsp.get_active_clients())<CR>:e<CR>") -- restart language servers

-- Telescope integration
local telescope_builtin = require("telescope.builtin")

mapper("n", "<Leader>ff", telescope_builtin.find_files) -- search all files, respecting .gitignore if one exists
mapper("n", "<Leader>fb", telescope_builtin.buffers) -- search open buffers
mapper("n", "<Leader>fl", telescope_builtin.current_buffer_fuzzy_find) -- search lines in current buffer
mapper("n", "<Leader>gg", telescope_builtin.live_grep) -- search all lines in project
mapper("n", "<Leader>fr", telescope_builtin.lsp_references) -- search references to symbol under cursor
mapper("n", "<Leader>co", telescope_builtin.colorscheme) -- colorschemes
mapper("n", "<Leader>gc", telescope_builtin.git_branches) -- checkout different branches
mapper("n", "<Leader>re", telescope_builtin.git_commits) -- checkout commits; <CR> to checkout, <C-r>[m, s, h] to reset [mixed, soft, hard]
-- jump to items in quickfix list
mapper("n", "<Leader>qf", function()
    -- open picker at bottom of window to match where the quickfix list already is
    telescope_builtin.quickfix(require("telescope.themes").get_ivy())
end)
mapper("n", "H", vim.lsp.buf.code_action) -- code actions (handled by telescope-ui-select)
mapper("n", "<Leader>dd", "<cmd>Telescope dap commands<CR>") -- debugger actions

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

-- Git things
mapper("n", "<Leader>gs", ":tab Git<CR>") -- `git status` in a new tab to save screen real estate
mapper("n", "<Leader>gd", "<cmd>Gdiffsplit<CR>") -- open a split diffing the current file

-- DAP
local dap = require("dap")
mapper("n", "<Leader>dr", dap.continue) -- start debugging session/continue execution
mapper("n", "<Leader>db", dap.toggle_breakpoint)
mapper("n", "<Leader>di", dap.step_into)
mapper("n", "<Leader>do", dap.step_over)
mapper("n", "<Leader>dq", ":call dap#shutdown()<CR>") -- custom shtudown handler that closes dapui, event listeners aren't working
