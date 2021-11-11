#!/bin/bash

export CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
if [[ ! -d "$CONFIG_HOME" ]]; then
    mkdir -p "$CONFIG_HOME"
fi
export NVIM_HOME=$CONFIG_HOME/nvim
export DF_HOME=$HOME/dotfiles

HAS_BREW=$(command -v brew)

function usage {
    echo "USAGE: $0 [bash, brew, nvim, tmux, zsh, alacritty, packages, all]"
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

function setup_brew {
    exists="$HAS_BREW"
    # no brew, install it
    if [[ ! $exists ]]; then
        echo "No brew installation found, installing..."
        runcmd /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    fi

    runcmd brew update
}

function install_packages {
    #APT_PACKAGES=( 'liblzma-dev' 'libsqlite3-dev' 'unixodbc-dev' ) # TODO: add to this
    # APT packages __should__ be taken care of by brew now
    BREW_PACKAGES=( 'gcc' 'fzf' 'bat' 'ripgrep' 'exa' 'pyenv' 'yarn' 'neovim' 'xz' 'sqlite' 'unixodbc' 'tmux' 'ninja' 'zsh' )

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

    echo ""
    echo "installing from npm..."
    if [[ -d "$HOME/.nvm" ]]; then
        echo "nvm is already installed"
    else
        echo "installing nvm"
        runcmd curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
        source "$HOME/.bashrc"
    fi
    if [[ ! $(command -v node) ]]; then
        echo "installing node"
        runcmd nvm install node
    fi
    NPM_PACKAGES=( 'bash-language-server' 'pyright' 'vls' 'typescript-language-server' 'vscode-langservers-extracted')
    npm_installed=$(npm -g list)
    for pkg in ${NPM_PACKAGES[@]}; do
        if [[ $(echo "$npm_installed" | grep -c "$pkg") -ge 1 ]]; then
            echo "$pkg already installed, skipping"
        else
            runcmd npm i -g "$pkg"
        fi
    done
    YARN_PACKAGES=( 'yaml-language-server' )
    if [[ $(command -v yarn) ]]; then
        yarn_installed=$(yarn global list)
        for pkg in ${YARN_PACKAGES[@]}; do
            if [[ $(echo "$yarn_installed" | grep -c "$pkg") -ge 1 ]]; then
                echo "$pkg already installed, skipping"
            else
                runcmd yarn global add "$pkg"
            fi
        done
    fi

    echo ""
    echo "installing python"
    runcmd git clone https://github.com/momo-lab/xxenv-latest.git "$(pyenv root)"/plugins/xxenv-latest
    runcmd pyenv latest install --skip-existing
    if [[ "$PYENV_VERSION" != "" ]]; then
        # Also install defined version
        runcmd pyenv install --skip-existing "$PYENV_VERSION"
    fi

    echo ""
    echo "installing from pip"
    echo "setting up debugpy"
    cur_pwd=$(pwd)
    runcmd "mkdir -p ~/.virtualenvs && cd ~/.virtualenvs"
    runcmd python -m venv debugpy
    runcmd debugpy/bin/python -m pip install debugpy
    cd "$cur_pwd"
}

function setup_bash {
    # .profile sourced automatically by bash
    file="$HOME/.profile"
    backup_file $file
    ln -s "$DF_HOME/files/.profile" "$file"
    # .profile sources .bashrc
    file="$HOME/.bashrc"
    backup_file $file
    ln -s "$DF_HOME/files/.bashrc" "$file"
    # .bashrc sources .aliases
    file="$HOME/.aliases"
    backup_file $file
    ln -s "$DF_HOME/files/.aliases" "$file"

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
    # Optionally install lua language server. Everything else is done in
    # install_packages
    read -p "Install sumneko_lua? (y/n) " install_sumneko
    if [[ $install_sumneko == "y" ]]; then
        local old_pwd=$(pwd)

        # clone project
        git clone https://github.com/sumneko/lua-language-server "$HOME/"
        cd "$HOME/lua-language-server"
        git submodule update --init --recursive
        # build
        cd 3rd/luamake
        compile/install.sh
        cd ../..
        ./3rd/luamake/luamake/rebuild

        cd "$old_pwd"
    fi
}

function setup_tmux {
    file="$HOME/.tmux.conf"
    backup_file $file
    ln -s "$DF_HOME/files/.tmux.conf" "$file"
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
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
    file="$HOME/.zshrc"
    backup_file $file
    ln -s "$DF_HOME/files/.zshrc" "$file"
    # do aliases as well
    file="$HOME/.aliases"
    backup_file $file
    ln -s "$DF_HOME/files/.aliases" "$file"
}

function setup_alacritty {
    mkdir -p "$CONFIG_HOME/alacritty"
    file="$CONFIG_HOME/alacritty/alacritty.yml"
    backup_file $file
    ln -s "$DF_HOME/files/alacritty.yml" "$file"
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
            setup_zsh
            source "$HOME/.zshrc"
            ;;
        "alacritty")
            setup_alacritty
            ;;
        "all")
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
