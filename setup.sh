#!/bin/bash

export CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
if [[ ! -d "$CONFIG_HOME" ]];
    mkdir -p "$CONFIG_HOME"
fi
export NVIM_HOME=$CONFIG_HOME/nvim
export DF_HOME=$HOME/dotfiles

function usage {
    echo "USAGE: $0 [bash, brew, nvim, tmux, zsh]"
}

function backup_file {
    file=$1
    if [[ -e $file ]]; then
        if [[ -L $file ]]; then
            unlink $file
        else
            echo "backing up '$file' to '$file.backup'"
            mv $file "$file.backup"
        fi
    fi
}

function backup_dir {
    dir=$1
    # Symlink, just remove it
    if [[ -d $dir ]]; then
        if [[ -L $dir ]]; then
            unlink $dir
        else
            echo "backing up '$dir' to '$dir backup'"
            mv $dir "$dir backup"
        fi
    fi
}

function setup_brew {
    exists=$(command -v brew)
    # no brew, install it
    if [[ ! $exists ]]; then
        echo "No brew installation found, installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    fi

    brew update
    # install essentials
    brew install gcc
    brew install fzf
    # actually install fzf
    $(brew --prefix)/opt/fzf/install
    brew install bat
    brew install ripgrep
    brew install exa
    brew install pyenv
    brew install yarn
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
    # .bashrc sources .bash_aliases
    file="$HOME/.bash_aliases"
    backup_file $file
    ln -s "$DF_HOME/files/.bash_aliases" "$file"
}

function setup_nvim {
    setup_brew
    # install package manager, paq-nvim
    git clone https://github.com/savq/paq-nvim.git \
        "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/opt/paq-nvim
    mkdir -p "$HOME/.config"
    backup_dir "$NVIM_HOME"
    ln -s "$DF_HOME/files/nvim" "$NVIM_HOME"
    brew install neovim
    nvim +PaqInstall +qall
}

function setup_tmux {
    file="$HOME/.tmux.conf"
    backup_file $file
    ln -s "$DF_HOME/files/.tmux.conf" "$file"
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
            setup_bash
            setup_brew
            setup_nvim
            setup_tmux
            setup_zsh
            source "~/.bashrc"
            ;;
        "*")
            usage
            ;;
    esac
done
echo "Done!"
exit 0
