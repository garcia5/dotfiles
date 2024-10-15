#!/bin/bash

export CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
if [[ ! -d "$CONFIG_HOME" ]]; then
    mkdir -p "$CONFIG_HOME"
fi
export NVIM_HOME=$CONFIG_HOME/nvim
export DF_HOME=$HOME/dotfiles

HAS_PYENV="$(command -v pyenv)"
HAS_BREW="$(command -v brew)"
HAS_NPM="$(command -v npm)"
HAS_NVIM="$(command -v nvim)"

function runcmd {
    echo "$@"
    "$@"
}

function replace_file {
    local old_file=$1
    local new_file=$2
    if [[ -e "${old_file}" ]]; then
        if [[ -L "${old_file}" ]]; then
            runcmd unlink "${old_file}"
        else
            runcmd mv "${old_file}" "${old_file}.backup"
        fi
    fi

    if [[ -n "${new_file}" && -n "${old_file}" ]]; then
        ln -s "${new_file}" "${old_file}"
    fi
}

function replace_dir {
    local old_dir=$1
    local new_dir=$2
    if [[ -d "${old_dir}" ]]; then
        # Symlink, just remove it
        if [[ -L "${old_dir}" ]]; then
            runcmd unlink "${old_dir}"
        else
            runcmd mv "${old_dir}" "${old_dir} backup"
        fi
    fi

    if [[ -n "${new_dir}" && -n "${old_dir}" ]]; then
        ln -s "${new_dir}" "${old_dir}"
    fi
}

function install_npm {
    if [[ -d "$HOME/.nvm" ]]; then
        echo "found nvm installation $(nvm --verison)"
    else
        echo "installing nvm"
        runcmd curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
        export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
    fi

    if [[ -z "$(command -v node)" ]]; then
        echo "installing node"
        runcmd nvm install --latest-npm
    fi
}

function install_brew {
    if [[ -n "${HAS_BREW}" ]]; then
        echo "Existing brew installation found at ${HAS_BREW}"
        return
    fi
    # no brew, install it
    echo "No brew installation found, installing..."
    runcmd /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
    runcmd brew update
}

function install_sketchybar {
    runcmd brew tap FelixKratz/formulae
    runcmd brew install sketchybar

    replace_dir "$CONFIG_HOME/sketchybar" "$DF_HOME/files/sketchybar"
    runcmd brew services start sketchybar
}

function install_packages {
    if [[ -z "${HAS_BREW}" ]]; then
        echo "No brew installation found, exiting"
        exit 1
    fi

    echo ""
    echo "Installing from brew..."
    local brew_packages=( 'gcc' 'fzf' 'bat' 'ripgrep' 'eza' 'pyenv' 'yarn' 'neovim' 'xz' 'sqlite' 'unixodbc' 'tmux' 'ninja' 'zsh' 'git-delta' 'stylua' 'git-absorb' 'lua-language-server' 'efm-langserver' 'shellcheck' 'gh' )
    local brew_installed
    brew_installed="$(brew list)"
    for pkg in "${brew_packages[@]}"; do
        if [[ "$brew_installed" == *"$pkg"* ]]; then
            echo "$pkg already installed, skipping"
        else
            runcmd brew install "$pkg"
        fi
    done

    # extra setup for some pacakges
    # fzf
    if [[ -f "$(brew --prefix)/opt/fzf/install" ]]; then
        "$(brew --prefix)"/opt/fzf/install --no-update-rc
    fi
    if [[ -n "$(command -v bat)" ]]; then
        # bat themes
        mkdir -p "$(bat --config-dir)/themes"
        runcmd curl -o- https://raw.githubusercontent.com/enkia/enki-theme/master/scheme/Enki-Tokyo-Night.tmTheme \
                > "$(bat --config-dir)/themes/tokyonight_moon.tmTheme"
        runcmd curl -o- https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Mocha.tmTheme \
                > "$(bat --config-dir)/themes/Catppuccin Mocha.tmTheme"
        runcmd curl -o- https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Frappe.tmTheme \
                > "$(bat --config-dir)/themes/Catppuccin Frappe.tmTheme"
        runcmd curl -o- https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Latte.tmTheme \
                > "$(bat --config-dir)/themes/Catppuccin Latte.tmTheme"
        runcmd curl -o- https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Macchiato.tmTheme \
                > "$(bat --config-dir)/themes/Catppuccin Macchiato.tmTheme"
        runcmd bat cache --build
    fi
    if [[ -n "$(command -v pyenv)" ]]; then
        eval "$(pyenv init -)"
    fi

    if [[ -z "${HAS_NPM}" ]]; then
        echo "No npm installation found, exiting"
        exit 1
    fi
    echo "Installing from npm..."
    local npm_packages=( 'bash-language-server' 'pyright' 'typescript-language-server' 'vscode-langservers-extracted' 'yaml-language-server' 'eslint_d' '@fsouza/prettierd' '@vue/language-server' 'typescript' )
    local npm_installed
    npm_installed=$(npm -g list)
    for pkg in "${npm_packages[@]}"; do
        if [[ "$npm_installed" == *"$pkg"* ]]; then
            echo "$pkg already installed, skipping"
        else
            runcmd npm i -g "$pkg"
        fi
    done

}

function install_python {
    if [[ -z "${HAS_PYENV}" ]]; then
        echo "No pyenv installation found, exiting"
        exit 1
    fi

    echo ""
    echo "Installing python"
    runcmd git clone https://github.com/momo-lab/xxenv-latest.git "$(pyenv root)"/plugins/xxenv-latest
    runcmd pyenv latest install --skip-existing
    if [[ "$PYENV_VERSION" != "" ]]; then
        # Also install defined version
        runcmd pyenv install --skip-existing "$PYENV_VERSION"
    fi
}


function setup_nvim {
    if [[ -z "${HAS_NVIM}" ]]; then
        echo "No neovim installation found, installing from brew"
        brew install neovim > /dev/null 2>&1 || echo "Unable to install neovim, exiting" && exit 1
    fi
    mkdir -p "$NVIM_HOME"
    replace_dir "$NVIM_HOME" "$DF_HOME/files/nvim"
    # Set up neovim python virtualenv
    if [[ ! -d "$HOME/py3nvim" && "$(python --version)" != 2* ]]; then
        runcmd python -m venv "$HOME/py3nvim"
        runcmd source "$HOME/py3nvim/bin/activate"
        runcmd pip install --upgrade pip
        runcmd pip install pynvim
        runcmd deactivate
    fi
    if [[ -n "${HAS_NPM}" && "$(npm ls -g)" != *neovim* ]]; then
        runcmd npm i -g neovim
    fi
}

function setup_tmux {
    replace_file "$HOME/.tmux.conf" "$DF_HOME/files/tmux.conf" 
}

function setup_zsh {
    if [[ ! $(command -v zsh) ]]; then
        echo "Command zsh not found, install it first"
        exit 1
    fi
    # get oh-my-zsh first
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Installing oh-my-zsh"
        runcmd sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    DEFAULT_ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
    mkdir -p "${DEFAULT_ZSH_CUSTOM}/plugins"
    mkdir -p "${DEFAULT_ZSH_CUSTOM}/themes"

    # get plugins
    # vi mode
    local vi_mode="${ZSH_CUSTOM:-$DEFAULT_ZSH_CUSTOM}/plugins/zsh-vi-mode"
    if [[ ! -d "${vi_mode}" ]]; then
        runcmd git clone https://github.com/jeffreytse/zsh-vi-mode "${vi_mode}"
    fi

    # syntax highlighting
    local syntax_highlighting="${ZSH_CUSTOM:-$DEFAULT_ZSH_CUSTOM}/plugins/zsh-vi-mode"
    if [[ ! -d "${syntax_highlighting}" ]]; then
        runcmd git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${syntax_highlighting}"
    fi

    # main
    replace_file "$HOME/.zshrc" "$DF_HOME/files/zshrc"
    replace_file "$HOME/.aliases" "$DF_HOME/files/aliases"
    replace_file "$HOME/.functions" "$DF_HOME/files/functions"
    # custom theme
    replace_file "${ZSH_CUSTOM:-$DEFAULT_ZSH_CUSTOM}/themes/quarter-life.zsh-theme" "$DF_HOME/files/quarter-life.zsh-theme" 

    # do syntax highlighting themes
    mkdir -p "$HOME/.zsh"
    runcmd curl -o- https://raw.githubusercontent.com/catppuccin/zsh-syntax-highlighting/main/themes/catppuccin_frappe-zsh-syntax-highlighting.zsh \
        > "$HOME/.zsh/catppuccin_frappe-zsh-syntax-highlighting.zsh"
    runcmd curl -o- https://raw.githubusercontent.com/catppuccin/zsh-syntax-highlighting/main/themes/catppuccin_latte-zsh-syntax-highlighting.zsh \
        > "$HOME/.zsh/catppuccin_latte-zsh-syntax-highlighting.zsh"
    runcmd curl -o- https://raw.githubusercontent.com/catppuccin/zsh-syntax-highlighting/main/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh \
        > "$HOME/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh"
    runcmd curl -o- https://raw.githubusercontent.com/catppuccin/zsh-syntax-highlighting/main/themes/catppuccin_macchiato-zsh-syntax-highlighting.zsh \
        > "$HOME/.zsh/catppuccin_macchiato-zsh-syntax-highlighting.zsh"
}

function install_scripts {
    # link files 1 by 1 to avoid overwriting any other custom stuff in there
    local dir="$HOME/bin"
    mkdir -p "$dir"
    local files
    files=$(ls "$DF_HOME/files/bin/")
    for file in "${files[@]}"; do
        replace_file "$HOME/bin/$file" "$DF_HOME/files/bin/$file"
    done
}

function setup_kitty {
    replace_dir "$CONFIG_HOME/kitty" "$DF_HOME/files/kitty"
}

function setup_alacritty {
    replace_dir "$CONFIG_HOME/alacritty" "$DF_HOME/files/alacritty"
}

function setup_wez {
    # Download & compile wezterm terminfo
    local tempfile
    tempfile=$(mktemp) \
      && curl -o "$tempfile" https://raw.githubusercontent.com/wez/wezterm/main/termwiz/data/wezterm.terminfo \
      && tic -x -o ~/.terminfo "$tempfile" \
      && rm "$tempfile"

    replace_file "$HOME/.wezterm.lua" "$DF_HOME/files/wezterm.lua"
}

function setup_dev {
    # first install package managers
    install_brew
    install_npm

    # install packages
    install_packages

    # install tools
    install_python
    setup_tmux
    setup_nvim
    install_scripts

    # shell
    setup_zsh

    # terminal
    setup_wez

    runcmd source "$HOME/.zshrc"
}

function usage {
    echo "USAGE: source $0 [dev, packages, sketchybar, wezterm, kitty, alacritty]"
}


for conf in "$@"; do
    case "$conf" in
        "dev")
            setup_dev
            ;;
        "packages")
            install_packages
            ;;
        "sketchybar")
            install_sketchybar
            ;;
        "wezterm")
            setup_wez
            ;;
        "kitty")
            setup_kitty
            ;;
        "alacritty")
            setup_alacritty
            ;;
        "*")
            usage
            ;;
    esac
done
echo "Done!"
exit 0
