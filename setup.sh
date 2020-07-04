#!/bin/bash

export CONFIG_HOME=$HOME/.config
export NVIM_HOME=$CONFIG_HOME/nvim
export DF_HOME=$HOME/dotfiles

function usage {
    echo "USAGE: $0 [bash, brew, nvim, tmux, vim, zsh]"
}

function setup_brew {
    exists=`which brew | wc -c`
    # no brew, install it
    if [[ $exists == 0 ]]; then
        # TODO: linuxbrew distinction?
        echo "No brew installation found, installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    fi

    brew update
    for package in `cat ./files/.brew-installed`; do
        echo "installing $package"
        output=`brew install $package`
    done
}

function backup_file {
    file=$1
    if [ -e $file ]; then
        mv $file "$file.backup"
    fi
}

function setup_bash {
    file="$HOME/.bash_profile"
    backup_file $file
    ln -s "$DF_HOME/files/.bash_profile" "$file"
    echo "source $HOME/.bash_profile" >> ~/.bashrc
}

function setup_nvim {
    # Create python environment for vim first
    if ! [ -d $HOME/nvim-env ]; then
        python3 -m venv "$HOME/nvim-env"
    fi
    file="$NVIM_HOME/init.vim"
    backup_file $file
    ln -s "$DF_HOME/files/init.vim" "$file"
    setup_vim
}

function setup_tmux {
    file="$HOME/.tmux.conf"
    backup_file $file
    ln -s "$DF_HOME/files/.tmux.conf" "$file"
}

function setup_vim {
    # install vim plug first
    curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    file="$HOME/.vimrc"
    backup_file $file
    ln -s "$DF_HOME/files/.vimrc" "$file"
}

function setup_zsh {
    file="$HOME/.zshrc"
    backup_file $file
    ln -s "$DF_HOME/files/.zshrc" "$file"
}

for conf in "$@"; do
    case "$conf" in
        "bash")
            setup_bash
            source "~/.bashrc"
            ;;
        "brew")
            setup_brew
            ;;
        "nvim")
            setup_nvim
            ;;
        "tmux")
            setup_tmux
            ;;
        "vim")
            setup_vim
            ;;
        "zsh")
            setup_zsh
            ;;
        "all")
            setup_brew
            setup_bash
            source "~/.bashrc"
            setup_nvim
            setup_tmux
            setup_zsh
            ;;
        "*")
            usage
            ;;
    esac
done
