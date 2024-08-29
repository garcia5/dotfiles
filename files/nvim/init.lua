-- Essentials
vim.g.mapleader = " "
vim.g.bulitin_lsp = true
vim.opt.termguicolors = true

-- Disable providers for faster startup
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Plugins
vim.loader.enable() -- cache lua modules (https://github.com/neovim/neovim/pull/22668)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("ag.plugins", {
    change_detection = {
        -- automatically check for config file changes and reload the ui
        enabled = true,
        notify = false,
    },
})

-- Keymaps
require("ag.mappings")

-- Behaviors
vim.opt.belloff = "all" -- NO BELLS!
vim.opt.completeopt = { "menuone", "noselect" } -- ins-completion how I like it
vim.opt.swapfile = false -- no swap files
vim.opt.inccommand = "nosplit" -- preview %s commands live as I type
vim.opt.undofile = true -- keep track of my 'undo's between sessions
vim.opt.grepprg = "rg --vimgrep --smart-case --no-heading" -- search with rg
vim.opt.grepformat = "%f:%l:%c:%m" -- filename:line number:column number:error message
vim.opt.mouse = "nv" -- use mouse in normal, visual modes
vim.opt.mousescroll = "ver:3,hor:0" -- scroll vertically by 3 lines, no horizontal scrolling
vim.opt.scrolloff = 10 -- padding between cursor and top/bottom of window
vim.opt.foldlevel = 0 -- allow folding the whole way down
vim.opt.foldlevelstart = 99 -- open files with all folds open
vim.opt.splitright = true -- prefer vsplitting to the right
vim.opt.splitbelow = true -- prefer splitting below
vim.opt.splitkeep = "screen" -- keep text on screen the same when splitting
vim.opt.wrap = false -- don't wrap my text
vim.opt.linebreak = true -- if I toggle `wrap` ON, only break between words

-- Indentation
vim.opt.autoindent = true -- continue indentation to new line
vim.opt.smartindent = true -- add extra indent when it makes sense
vim.opt.smarttab = true -- <Tab> at the start of a line behaves as expected
vim.opt.expandtab = true -- <Tab> inserts spaces
vim.opt.shiftwidth = 4 -- >>, << shift line by 4 spaces
vim.opt.tabstop = 4 -- <Tab> appears as 4 spaces
vim.opt.softtabstop = 4 -- <Tab> behaves as 4 spaces when editing

-- Colors
vim.cmd("colorscheme catppuccin")
if vim.fn.environ()["THEME_MODE"] == "Light" then
    vim.opt.background = "light"
else
    vim.opt.background = "dark"
end

-- Look and feel
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes" -- show the sign column always
vim.opt.list = true -- show list chars
vim.opt.foldtext = "" -- show normal buffer content (w/ highlights) through fold
vim.opt.showbreak = "> " -- prefix wrapped lines with '>'
vim.opt.listchars = {
    -- these list chars
    tab = "<->",
    nbsp = "␣",
    extends = "…",
    precedes = "…",
    trail = "·",
    multispace = "·", -- show chars if I have multiple spaces between text
    leadmultispace = " ", -- ...but don't show any when they're at the start
}
-- more defined window border
vim.opt.fillchars:append({
    vert = "┃",
    horiz = "━",
    horizup = "┻",
    horizdown = "┳",
    vertleft = "┫",
    vertright = "┣",
    verthoriz = "╋",
    diff = "╱",
})
vim.opt.cursorline = true -- hightlight line cursor is on
vim.opt.laststatus = 3 -- single global statusline

-- Searching
vim.opt.wildmenu = true -- tab complete on command line
vim.opt.ignorecase = true -- case insensitive search...
vim.opt.smartcase = true -- unless I use caps
vim.opt.hlsearch = true -- highlight matching text
vim.opt.incsearch = true -- update results while I type
