# Dotfiles

My own personal configurations, `setup.sh` sort of works to get things set up

## Neovim
- [init.lua](./files/nvim/init.lua): Config entry point. Configures basic options, loads [Lazy](https://github.com/folke/lazy.nvim) plugin manager
- [lua/ag/mappings.lua](./files/nvim/lua/ag/mappings.lua): All *general* mappings, nothing plugin specific
- [lua/ag/plugins/](./files/nvim/lua/ag/plugins/): All the plugins I use
- [lua/ag/lsp_config.lua](./files/nvim/lua/ag/lsp_config.lua): LSP configs for the languages I typically use
- [lua/ag/snippets](./files/nvim/lua/ag/snippets/): [LuaSnip](https://github.com/L3MON4D3/LuaSnip) snippet definitions, loaded by [luasnip.lua](./files/nvim/lua/ag/plugins/luasnip.lua) plugin
- [after/plugin/autocmd.lua](./files/nvim/after/plugin/autocmd.lua): Place to stuff all my autocommands
- [after/ftplugin/](./files/nvim/after/ftplugin/): Language-specific editor configuration (special mappings, tab width, etc)

## Shell/Terminal
- [zshrc](./files/zshrc): Main ZSH configuration, uses [oh-my-zsh](https://ohmyz.sh/) and pulls in a few other scripts
  - [quarter-life.zsh-theme](./files/quarter-life.zsh-theme): A simpler version of the half-life oh-my-zsh theme
  - [functions](./files/functions): More complex terminal functions, primarily focused on [FZF](https://github.com/junegunn/fzf) integration
- [wezterm.lua](./files/wezterm.lua): My current terminal config
- [tmux.conf](./files/tmux.conf): My tmux config for when I can't use wezterm

## Sketchybar
A customizable MacOS menu bar - https://github.com/FelixKratz/SketchyBar

All configuration is in [files/sketchybar/](./files/sketchybar/)

TODO:
- **Use `g` commands more**

## GH PR review plugin
**Goal:** Add comments to a PR and submit a review from nvim

### Entry
`:ReviewGithub open <pr number>`
1. checkout branch associated w/ PR (`gh pr checkout <pr number>`)
2. diff against base branch base branch = `gh pr view --json baseRefName --jq .baseRefName` -> `:DiffviewOpen <base ref>`

### Functionality
- [ ] `:ReviewGithub start`
  - begin new review (?)
- [ ] `:ReviewGithub comment <comment text>`
  - modes: n, v
  - adds comment to current line, selected lines
- [ ] `:ReviewGithub submit|approve|reject`

### Unknowns
[!QUESTION] What are the "states" of a pull request?
[!QUESTION] How do you add/store comments without submitting the review?

