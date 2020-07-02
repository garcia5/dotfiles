#!/bin/bash

export CONFIG_HOME=$HOME/.config
export NVIM_HOME=$CONFIG_HOME/nvim
export DF_HOME=$HOME/dotfiles

function usage {
    echo "USAGE: $0 [bash, brew, nvim, tmux, vim, zsh]"
}

function install_brew {
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
    if [-e $file]; then
        mv $file "$file.backup"
    fi
}

# TODO backup old files if they already exist
function setup_bash {
    file="$HOME/.bashrc"
    backup_file $file
    ln -s "./files/.bashrc" "$file"
}

function setup_nvim {
    if ! [-d $HOME/nvim-env]; then
        python3 -m venv "$HOME/nvim-env"
    fi
    file="$NVIM_HOME/init.vim"
    backup_file $file
    ln -s "./files/init.vim" "$file"
    setup_vim
}

function setup_tmux {
    file="$HOME/.tmux.conf"
    backup_file $file
    ln -s "./files/.tmux.conf" "$file"
}

function setup_vim {
    # install vim plug
    curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    file="$HOME/.vimrc"
    backup_file $file
    ln -s "./files/.vimrc" "$file"
}

function setup_zsh {
    file="$HOME/.zshrc"
    backup_file $file
    ln -s "./files/.zshrc" "$file"
}

for conf in "$@"; do
    case "$conf" in
        "bash")
            setup_bash
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
        "*")
            usage
            ;;
    esac
done
