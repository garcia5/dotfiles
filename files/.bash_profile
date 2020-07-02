
# Setting PATH for Python 3.7
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
export PATH
export PATH="/usr/local/bin:$PATH"
export CLICOLORS=1
export LSCOLORS=cxfxcxdxexegedabagacad
export PS1="\u \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "

# Colors
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"
set -o vi

alias la='ls -aG'
alias ll='ls -hlaSG'
alias ls='ls -G'
alias vim='nvim'
alias pip='pip3'
alias python='python3'
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# fzf command
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
# fzf options
export FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --preview 'bat --color=always --style=header,grid --line-range :300 {}'"

#thefuck
alias fuck='thefuck'

export PATH="$HOME/.cargo/bin:$PATH"
