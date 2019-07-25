
# Setting PATH for Python 3.7
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
export PATH

# Colors
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

alias la='ls -a'
alias ll='ls -la'
alias vim='nvim'
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

#thefuck
eval $(thefuck --alias fuck)
