#!/bin/bash

export CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
if [[ ! -d "$CONFIG_HOME" ]]; then
    mkdir -p "$CONFIG_HOME"
fi
export NVIM_HOME=$CONFIG_HOME/nvim
export DF_HOME=$HOME/dotfiles

function usage {
    echo "USAGE: $0 [bash, brew, nvim, tmux, zsh, all]"
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
    if [[ -d $dir ]]; then
        # Symlink, just remove it
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

    echo "brew update"
    brew update
}

function install_packages {
    APT_PACKAGES=( 'liblzma-dev' 'libsqlite3-dev' 'unixodbc-dev' ) # TODO: add to this
    BREW_PACKAGES=( 'gcc' 'fzf' 'bat' 'ripgrep' 'exa' 'pyenv' 'yarn' 'neovim' 'xz' )

    if [[ $(command -v apt-get) ]]; then
        echo ""
        echo "installing from apt..."
        echo "sudo apt-get update"
        sudo apt-get update
        for pkg in ${APT_PACKAGES[@]}; do
            echo "sudo apt-get install $pkg"
            sudo apt-get install "$pkg"
        done
    fi

    if [[ $(command -v brew) ]]; then
        echo ""
        echo "installing from brew..."
        brew update
        for pkg in ${BREW_PACKAGES[@]}; do
            if [[ $(brew list | grep -c "$pkg") -ge 1 ]]; then
                echo "$pkg already installed, skipping"
            else
                echo "brew install $pkg"
                brew install "$pkg"
                if [[ "$pkg" == "fzf" ]]; then
                    # Actually install fzf
                    $(brew --prefix)/opt/fzf/install
                fi
            fi
        done
    fi

    echo ""
    echo "installing from npm..."
    if [[ -d "$HOME/.nvm" ]]; then
        echo "nvm is already installed"
    else
        echo "installing nvm"
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
        source "$HOME/.bashrc"
    fi
    if [[ ! $(command -v node) ]]; then
        echo "installing node"
        echo "nvm install node"
        nvm install node
    fi
    NPM_PACKAGES=( 'bash-language-server' 'pyright' 'vls' 'typescript-language-server' )
    for pkg in ${NPM_PACKAGES[@]}; do
        if [[ $(npm -g list | grep -c "$pkg") -ge 1 ]]; then
            echo "$pkg already installed, skipping"
        else
            echo "npm i -g $pkg"
            npm i -g "$pkg"
        fi
    done
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

    # Color schemes
    if [[ ! $(-d $HOME/.config/base16-shell) ]]; then
        echo 'Installing colorschemes to $HOME/.config/base16-shell'
        git clone https://github.com/chriskempson/base16-shell.git $HOME/.config/base16-shell
    fi
}

function setup_nvim {
    setup_brew
    install_packages
    mkdir -p "$HOME/.config"
    backup_dir "$NVIM_HOME"
    ln -s "$DF_HOME/files/nvim" "$NVIM_HOME"
    # Install all plugins
    nvim +PackerSync +qall
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
        "all")
            setup_bash
            setup_brew
            install_packages
            setup_nvim
            setup_tmux
            setup_zsh
            source "$HOME/.profile"
            ;;
        "*")
            usage
            ;;
    esac
done
source "$HOME/.profile"
echo "Done!"
exit 0
