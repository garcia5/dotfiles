#!/bin/bash

export CONFIG_HOME=$HOME/.config
export NVIM_HOME=$CONFIG_HOME/nvim
export DF_HOME=$HOME/dotfiles

function usage {
    echo "USAGE: $0 [bash, brew, nvim, tmux, zsh]"
}

function backup_file {
    file=$1
    echo "backing up '$file' to '$file.backup'"
    if [ -e $file ]; then
        mv $file "$file.backup"
    fi
}

function backup_dir {
    dir=$1
    echo "backing up '$dir' to '$dir backup'"
    if [ -d $dir ]; then
        mv $dir "$dir backup"
    fi
    if [[ -L $dir && -d $dir ]]; then
        rm $dir
    fi
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
        brew install $package
    done
}

function setup_bash {
    file="$HOME/.bash_profile"
    backup_file $file
    ln -s "$DF_HOME/files/.bash_profile" "$file"
    echo "source $HOME/.bash_profile" >> ~/.bashrc
}

function setup_nvim {
    dir="$NVIM_HOME"
    backup_dir $dir
    ln -s "$DF_HOME/files/nvim" "$dir"
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
    echo "setting up $conf..."
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
        "zsh")
            setup_zsh
            source "~/.zshrc"
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
echo "Done!"
exit 0
