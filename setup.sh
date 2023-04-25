#!/bin/bash

export CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
if [[ ! -d "$CONFIG_HOME" ]]; then
    mkdir -p "$CONFIG_HOME"
fi
export NVIM_HOME=$CONFIG_HOME/nvim
export DF_HOME=$HOME/dotfiles

HAS_BREW=$(command -v brew)
HAS_PYENV=$(command -v pyenv)

function usage {
    echo "USAGE: $0 [bash, brew, nvim, tmux, zsh, alacritty, kitty, git, packages, all]"
}

function runcmd {
    echo "$@"
    eval "$@"
}

function backup_file {
    file=$1
    if [[ -e $file ]]; then
        if [[ -L $file ]]; then
            runcmd unlink $file
        else
            runcmd mv $file "$file.backup"
        fi
    fi
}

function backup_dir {
    dir=$1
    if [[ -d $dir ]]; then
        # Symlink, just remove it
        if [[ -L $dir ]]; then
            runcmd unlink $dir
        else
            runcmd mv $dir "$dir backup"
        fi
    fi
}

function git_config {
    local cmd="git config --global"
    runcmd "$cmd" $@
}

function setup_git {
    # aliases
    git_config alias.plog "log --pretty --oneline --decorate"
    git_config alias.update "fetch origin master:master"
    git_config alias.cleanup "! zsh -i -c 'git branch --merged master | grep -v master | xargs git branch -d'"
    git_config alias.fixup "! zsh -i -c 'git commit --fixup=\$(fzf-git-commits)'"
    git_config alias.rockstars "shortlog -s -n --no-merges"
    git_config alias.count-lines "! git log --author=\"\$1\" --pretty=tformat: --numstat | awk '{ add += \$1; subs += \$2; loc += \$1 - \$2 } END { printf \"added lines: %s, removed lines: %s, total lines: %s\n\", add, subs, loc }' #"

    # settings
    git_config core.pager "delta"
    git_config push.autoSetupRemove "true"
    git_config fetch.prune "true"
    git_config pull.rebase "true"

    # colors
    git_config diff.colorMoved "zebra"
    # delta
    git_config delta.features "decorations"
    git_config delta.file-decoration-style "blue bold ol ul"
    git_config delta.hunk-header-style "file line-number syntax"
    git_config delta.hunk-header-decoration-style "blue"
    git_config delta.hunk-label ">>>"
    git_config delta.line-numbers "true"
    git_config delta.hyperlinks "true"
    # tokyonight-moon theme
    git_config delta.minus-style                   'syntax "#3a273a"'
    git_config delta.minus-non-emph-style          'syntax "#3a273a"'
    git_config delta.minus-emph-style              '"#1b1d2b" "#c53b53"'
    git_config delta.minus-empty-line-marker-style 'syntax "#3a273a"'
    git_config delta.plus-style                    'syntax "#273849"'
    git_config delta.plus-non-emph-style           'syntax "#273849"'
    git_config delta.plus-emph-style               '"#1b1d2b" "#41a6b5"'
    git_config delta.plus-empty-line-marker-style  'syntax "#273849"'

    # `git-absorb`
    git_config absorb.maxStack 20
}

function setup_brew {
    exists="$HAS_BREW"
    # no brew, install it
    if [[ ! $exists ]]; then
        echo "No brew installation found, installing..."
        runcmd /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    fi
    eval $(/opt/homebrew/bin/brew shellenv)

    runcmd brew update
}

function install_packages {
    BREW_PACKAGES=( 'gcc' 'fzf' 'bat' 'ripgrep' 'exa' 'pyenv' 'yarn' 'neovim' 'xz' 'sqlite' 'unixodbc' 'tmux' 'ninja' 'zsh' 'git-delta' 'tree' 'git-absorb' )

    echo ""
    echo "installing from brew..."
    if [[ ! "$HAS_BREW" ]]; then
        echo "installing brew first"
        setup_brew
    fi
    runcmd brew update
    brew_installed=$(brew list)
    for pkg in ${BREW_PACKAGES[@]}; do
        if [[ $(echo "$brew_installed" | grep -c "$pkg") -ge 1 ]]; then
            echo "$pkg already installed, skipping"
        else
            runcmd brew install "$pkg"
            if [[ "$pkg" == "fzf" ]]; then
                # Actually install fzf
                $(brew --prefix)/opt/fzf/install
            fi
        fi
    done
    # Install sketchybar from tap
    runcmd brew tap FelixKratz/formulae
    runcmd brew install sketchybar

    echo ""
    echo "installing from npm..."
    if [[ -d "$HOME/.nvm" ]]; then
        echo "found nvm installation $(nvm --verison)"
    else
        echo "installing nvm"
        runcmd curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
        source "$HOME/.bashrc"
    fi
    if [[ ! $(command -v node) ]]; then
        echo "installing node"
        runcmd nvm install node
    fi
    NPM_PACKAGES=( 'bash-language-server' 'pyright' 'vls' 'typescript-language-server' 'vscode-langservers-extracted' 'neovim' 'yaml-language-server' 'eslint_d' )
    npm_installed=$(npm -g list)
    for pkg in ${NPM_PACKAGES[@]}; do
        if [[ $(echo "$npm_installed" | grep -c "$pkg") -ge 1 ]]; then
            echo "$pkg already installed, skipping"
        else
            runcmd npm i -g "$pkg"
        fi
    done

    echo ""
    echo "installing python"
    runcmd git clone https://github.com/momo-lab/xxenv-latest.git "$(pyenv root)"/plugins/xxenv-latest
    runcmd pyenv latest install --skip-existing
    if [[ "$PYENV_VERSION" != "" ]]; then
        # Also install defined version
        runcmd pyenv install --skip-existing "$PYENV_VERSION"
    fi
}

function setup_bash {
    # .profile sourced automatically by bash
    file="$HOME/.profile"
    backup_file $file
    ln -s "$DF_HOME/files/profile" "$file"
    # .profile sources .bashrc
    file="$HOME/.bashrc"
    backup_file $file
    ln -s "$DF_HOME/files/bashrc" "$file"
    # .bashrc sources .aliases
    file="$HOME/.aliases"
    backup_file $file
    ln -s "$DF_HOME/files/aliases" "$file"

    # Color schemes
    if [[ ! $(-d $HOME/.config/base16-shell) ]]; then
        echo 'Installing colorschemes'
        runcmd git clone https://github.com/chriskempson/base16-shell.git $HOME/.config/base16-shell
    fi
}

function setup_nvim {
    if [[ ! "$HAS_BREW" ]]; then
        setup_brew
    fi
    if [[ ! $(command -v nvim) ]]; then
        brew install neovim
    fi
    mkdir -p "$HOME/.config"
    backup_dir "$NVIM_HOME"
    ln -s "$DF_HOME/files/nvim" "$NVIM_HOME"
    # Set up neovim python virtualenv
    if [[ ! $(-d $HOME/py3nvim) ]]; then
        runcmd python -m venv "$HOME/py3nvim"
        runcmd source "$HOME/py3nvim/bin/activate"
        runcmd pip install --upgrade pip
        runcmd pip install pynvim
        runcmd deactivate
    fi
    # Optionally install lua language server. Everything else is done in
    # install_packages
    read -p "Install sumneko_lua? (y/n) " install_sumneko
    if [[ $install_sumneko == "y" ]]; then
        local old_pwd=$(pwd)

        # clone project
        git clone https://github.com/sumneko/lua-language-server "$HOME/lua-language-server"
        cd "$HOME/lua-language-server"
        git submodule update --init --recursive
        # build
        cd 3rd/luamake
        compile/install.sh
        cd ../..
        ./3rd/luamake/luamake rebuild

        cd "$old_pwd"
    fi
}

function setup_tmux {
    file="$HOME/.tmux.conf"
    backup_file $file
    ln -s "$DF_HOME/files/tmux.conf" "$file"
}

function setup_zsh {
    if [[ ! "$HAS_BREW" ]]; then
        setup_brew
    fi
    if [[ ! $(command -v zsh) ]]; then
        brew install zsh
    fi
    # get oh-my-zsh first
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        runcmd sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
    # get plugins
    # vi mode
    runcmd git clone https://github.com/jeffreytse/zsh-vi-mode \
      $ZSH_CUSTOM/plugins/zsh-vi-mode
    # syntax highlighting
    runcmd git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
      $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

    file="$HOME/.zshrc"
    backup_file $file
    ln -s "$DF_HOME/files/zshrc" "$file"
    # do aliases as well
    file="$HOME/.aliases"
    backup_file $file
    ln -s "$DF_HOME/files/aliases" "$file"
    # do functions
    file="$HOME/.functions"
    backup_file $file
    ln -s "$DF_HOME/files/functions" "$file"
    # do custom theme
    ln -s "$DF_HOME/files/quarter-life.zsh-theme" "$HOME/.oh-my-zsh/themes/quarter-life.zsh-theme"

    # Do sketchybar here?
    backup_dir "$CONFIG_HOME/sketchybar/"
    ln -s "$DF_HOME/files/sketchybar/" "$CONFIG_HOME/sketchybar"
    if [[ $(command -v sketchybar) ]]; then
        runcmd brew services start sketchybar
    fi

    # Do special scripts
    dir="$HOME/bin/"
    if [[ ! -d "$dir" ]]; then
        runcmd "mkdir -p $dir"
    fi
    files=$(ls "$DF_HOME/files/bin/")
    for file in ${files[@]}; do
        if [[ ! -f "$dir/$file" ]]; then
            runcmd ln -s "$DF_HOME/files/bin/$file" "$HOME/bin/$file"
        fi
    done
}

function setup_kitty {
    backup_dir "$CONFIG_HOME/kitty/"
    ln -s "$DF_HOME/files/kitty" "$CONFIG_HOME/kitty"
}

function setup_alacritty {
    backup_dir "$CONFIG_HOME/alacritty/"
    ln -s "$DF_HOME/files/alacritty/" "$CONFIG_HOME/alacritty"
}

for conf in "$@"; do
    echo "setting up $conf..."
    case "$conf" in
        "bash")
            setup_bash
            source "$HOME/.profile"
            ;;
        "brew")
            setup_brew
            install_packages
            ;;
        "nvim")
            setup_nvim
            ;;
        "tmux")
            setup_tmux
            ;;
        "zsh")
            install_packages
            setup_zsh
            source "$HOME/.zshrc"
            ;;
        "alacritty")
            setup_alacritty
            ;;
        "kitty")
            setup_kitty
            ;;
        "git")
            setup_git
        "all")
            setup_kitty
            setup_alacritty
            setup_brew
            install_packages
            setup_nvim
            setup_tmux
            setup_zsh
            ;;
        "install_packages")
            install_packages
            ;;
        "*")
            usage
            ;;
    esac
done
echo "Done!"
exit 0
