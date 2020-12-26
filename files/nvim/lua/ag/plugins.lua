-- Bootstrap packer.nvim
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
end

execute 'packadd packer.nvim'


-- Install plugins
return require('packer').startup(function()
    -- Packer can manage itself as an optional plugin
    use {'wbthomason/packer.nvim', opt = true}

    use 'scrooloose/nerdcommenter'
    use 'vim-airline/vim-airline'
    use 'vim-airline/vim-airline-themes'
    -- Use brew installed FZF for nvim
    -- Same as doing rtp+='/usr/local/bin/fzf'
    use '/usr/local/bin/fzf'
    -- better fzf integration
    use 'junegunn/fzf.vim'
    -- LSP
    use 'neovim/nvim-lsp'
    use 'neovim/nvim-lspconfig'
    use 'nvim-lua/completion-nvim'
    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'nvim-treesitter/nvim-treesitter'
    -- Git status in gutter
    use {'airblade/vim-gitgutter', opt = true}
    -- Surround
    use 'tpope/vim-surround'
    -- ... and make them repeatable
    use 'tpope/vim-repeat'
    -- Line it up
    use {'godlygeek/tabular', opt = true}

    -- Colorschemes
    -- anderson color scheme
    use 'gilgigilgil/anderson.vim'
    -- srecry color scheme
    use 'srcery-colors/srcery-vim'
    -- monokai pro color scheme
    use 'phanviet/vim-monokai-pro'
    -- corvine
    use 'arzg/vim-corvine'
    -- pretty colors
    use 'chriskempson/base16-vim'

    -- format on save
    use 'lukas-reineke/format.nvim'
end)
