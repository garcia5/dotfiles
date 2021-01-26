# garcia5 dotfiles

My own personal configurations, install any of them using the provided `setup.sh` script

```
setup.sh [bash, brew, nvim, tmux, zsh, ALL]
```

Symlinks the associated configuration file to the one in this repo and creates a copy of the original

## TODO
- nnoremap \<BS\> daw
- trigger signature help in insert mode
  - \<C-h\>?
- find something useful to do with \<CR\> in normal mode
  - :e! -- could be dangerous though, maybe just :e
- look into [chain completion](https://github.com/nvim-lua/completion-nvim/wiki/chain-complete-support#setup-chain-completion)
  - different sources between comments, other
  - use built-in file path completion as source
  - example [here](https://github.com/nvim-lua/completion-nvim/wiki/per-server-setup-by-lua#set-up-completion-nvim-by-lua)
- enable [trigger on delete](https://github.com/nvim-lua/completion-nvim#trigger-on-delete)
