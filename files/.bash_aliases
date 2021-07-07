# Essentials
alias ll='exa -hal'
alias la='exa -a'
alias vim='nvim'
alias claer='clear'

# Nav
alias gohome='cd /mnt/c/Users/agarcia02/'

# Git
alias gs='git status'
alias gd='git diff'
alias gl='git plog'
g_push() {
    cur_branch=$(git branch --show-current)
    has_remote=$(git branch -a --list "$cur_branch" | wc -l)
    if [ $has_remote ]; then
        git push "$@"
    else
        echo "No remote branch found, creating one"
        git push --set-upstream origin "$cur_branch" "$@"
    fi
}
alias gpush=g_push
fzf-git-branch() {
    git rev-parse HEAD > /dev/null 2>&1 || return

    git branch --color=always --all --sort=-committerdate |
        grep -v HEAD |
        fzf --height 50% --ansi --no-multi --preview-window right:65% \
        --preview 'git log -n 50 --color=always --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed "s/.* //" <<< {})' |
        sed "s/.* //"
}
fzf-git-checkout() {
    git rev-parse HEAD > /dev/null 2>&1 || return

    local branch

    branch=$(fzf-git-branch)
    if [[ "$branch" = "" ]]; then
        echo "No branch selected."
        return
    fi

    # If branch name starts with 'remotes/' then it is a remote branch. By
    # using --track and a remote branch name, it is the same as:
    # git checkout -b branchName --track origin/branchName
    if [[ "$branch" = 'remotes/'* ]]; then
        git checkout --track $branch
    else
        git checkout $branch;
    fi
}
alias gc='fzf-git-checkout'

# Others
alias senv='while read LINE; do export "$LINE"; done < ./.ENV'
