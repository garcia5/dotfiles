
# Setting PATH for Python 3.7
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
export PATH
export PATH="/usr/local/bin:$PATH"
export CLICOLORS=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Colors
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PS1="\u \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "

alias la='ls -a'
alias ll='ls -la'
alias vim='nvim'
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

#thefuck
alias fuck='thefuck'
