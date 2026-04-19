#!/bin/bash

set -eo pipefail

export CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
if [[ ! -d "$CONFIG_HOME" ]]; then
    mkdir -p "$CONFIG_HOME"
fi
export NVIM_HOME=$CONFIG_HOME/nvim
export DF_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function has_command {
    command -v "$1" >/dev/null 2>&1
}

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
        runcmd ln -sfn "${new_file}" "${old_file}"
    fi
}

function replace_dir {
    local old_dir=$1
    local new_dir=$2
    if [[ -d "${old_dir}" ]]; then
        if [[ -L "${old_dir}" ]]; then
            runcmd unlink "${old_dir}"
        else
            runcmd mv "${old_dir}" "${old_dir}.backup"
        fi
    fi

    if [[ -n "${new_dir}" && -n "${old_dir}" ]]; then
        runcmd ln -sfn "${new_dir}" "${old_dir}"
    fi
}

function install_npm {
    if [[ -d "$HOME/.nvm" ]]; then
        echo "found nvm installation"
    else
        echo "installing nvm"
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
        export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
    fi

    echo "installing node using nvm"
    runcmd nvm install --latest-npm
}

function install_brew {
    if has_command brew; then
        echo "Existing brew installation found at $(command -v brew)"
        return
    fi
    # no brew, install it
    echo "No brew installation found, installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if [[ -d "/opt/homebrew/bin" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -d "/usr/local/bin" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    runcmd brew update
}

function install_sketchybar {
    echo "Installing sketchybar..."
    # Installed via Brewfile
    replace_dir "$CONFIG_HOME/sketchybar" "$DF_HOME/files/sketchybar"
    runcmd brew services start sketchybar
}

function install_packages {
    if ! has_command brew; then
        echo "No brew installation found, attempting to install..."
        install_brew
    fi

    echo ""
    echo "Installing packages from Brewfile..."
    runcmd brew bundle --file="$DF_HOME/Brewfile"

    # extra setup for some packages
    # fzf
    local fzf_install_script
    fzf_install_script="$(brew --prefix)/opt/fzf/install"
    if [[ -f "$fzf_install_script" ]]; then
        "$fzf_install_script" --no-update-rc --no-bash --no-zsh --no-fish
    fi

    if has_command pyenv; then
        eval "$(pyenv init -)"
    fi

    if ! has_command npm; then
        echo "No npm installation found, installing node via nvm..."
        install_npm
    fi
    echo "Installing global npm packages..."
    local npm_packages=( 'bash-language-server' 'pyright' 'typescript-language-server' 'vscode-langservers-extracted' 'yaml-language-server' 'eslint_d' '@fsouza/prettierd' '@vue/language-server' 'typescript' )
    for pkg in "${npm_packages[@]}"; do
        if npm list -g "$pkg" >/dev/null 2>&1; then
            echo "$pkg already installed, skipping"
        else
            runcmd npm i -g "$pkg"
        fi
    done
}

# Catppuccin
function install_colorscheme {
    # zsh syntax highlighting
    mkdir -p "$HOME/.zsh"
    curl -o- https://raw.githubusercontent.com/catppuccin/zsh-syntax-highlighting/main/themes/catppuccin_frappe-zsh-syntax-highlighting.zsh \
        > "$HOME/.zsh/catppuccin_frappe-zsh-syntax-highlighting.zsh"
    curl -o- https://raw.githubusercontent.com/catppuccin/zsh-syntax-highlighting/main/themes/catppuccin_latte-zsh-syntax-highlighting.zsh \
        > "$HOME/.zsh/catppuccin_latte-zsh-syntax-highlighting.zsh"
    curl -o- https://raw.githubusercontent.com/catppuccin/zsh-syntax-highlighting/main/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh \
        > "$HOME/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh"
    curl -o- https://raw.githubusercontent.com/catppuccin/zsh-syntax-highlighting/main/themes/catppuccin_macchiato-zsh-syntax-highlighting.zsh \
        > "$HOME/.zsh/catppuccin_macchiato-zsh-syntax-highlighting.zsh"

    if command -v bat; then
        # bat themes
        mkdir -p "$(bat --config-dir)/themes"
        curl -o- https://raw.githubusercontent.com/enkia/enki-theme/master/scheme/Enki-Tokyo-Night.tmTheme \
                > "$(bat --config-dir)/themes/tokyonight_moon.tmTheme"
        curl -o- https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Mocha.tmTheme \
                > "$(bat --config-dir)/themes/Catppuccin Mocha.tmTheme"
        curl -o- https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Frappe.tmTheme \
                > "$(bat --config-dir)/themes/Catppuccin Frappe.tmTheme"
        curl -o- https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Latte.tmTheme \
                > "$(bat --config-dir)/themes/Catppuccin Latte.tmTheme"
        curl -o- https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Macchiato.tmTheme \
                > "$(bat --config-dir)/themes/Catppuccin Macchiato.tmTheme"
        runcmd bat cache --build
    fi

    if command -v delta; then
        # delta themes
        curl -o- https://raw.githubusercontent.com/catppuccin/delta/refs/heads/main/catppuccin.gitconfig \
            > "${HOME}/.catppuccin-delta.gitconfig"
    fi

    if command -v eza; then
        # better "LS_COLORS"
        mkdir -p "${CONFIG_HOME}/eza"
        curl -o- https://raw.githubusercontent.com/catppuccin/eza/refs/heads/main/themes/mocha/catppuccin-mocha-blue.yml \
            > "${CONFIG_HOME}/eza/theme.yml"
    fi
}

function install_python {
    if ! has_command pyenv; then
        echo "No pyenv installation found, skipping python setup"
        return
    fi

    echo ""
    echo "Installing python via pyenv..."
    local xxenv_latest_dir
    xxenv_latest_dir="$(pyenv root)/plugins/xxenv-latest"
    if [[ ! -d "$xxenv_latest_dir" ]]; then
        runcmd git clone https://github.com/momo-lab/xxenv-latest.git "$xxenv_latest_dir"
    fi
    runcmd pyenv latest install --skip-existing
    if [[ -n "${PYENV_VERSION:-}" ]]; then
        # Also install defined version
        runcmd pyenv install --skip-existing "$PYENV_VERSION"
    fi
}


function setup_nvim {
    if ! has_command nvim; then
        echo "Neovim not found, installing via brew..."
        runcmd brew install neovim
    fi
    mkdir -p "$NVIM_HOME"
    replace_dir "$NVIM_HOME" "$DF_HOME/files/nvim"
}

function setup_tmux {
    replace_file "$HOME/.tmux.conf" "$DF_HOME/files/tmux.conf"
}

function setup_zsh {
    if ! has_command zsh; then
        echo "Command zsh not found, install it first"
        exit 1
    fi
    # get oh-my-zsh first
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Installing oh-my-zsh"
        runcmd sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    local DEFAULT_ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
    mkdir -p "${DEFAULT_ZSH_CUSTOM}/plugins"
    mkdir -p "${DEFAULT_ZSH_CUSTOM}/themes"

    # get plugins
    # vi mode
    local vi_mode="${ZSH_CUSTOM:-$DEFAULT_ZSH_CUSTOM}/plugins/zsh-vi-mode"
    if [[ ! -d "${vi_mode}" ]]; then
        runcmd git clone https://github.com/jeffreytse/zsh-vi-mode "${vi_mode}"
    fi

    # syntax highlighting
    local syntax_highlighting="${ZSH_CUSTOM:-$DEFAULT_ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
    if [[ ! -d "${syntax_highlighting}" ]]; then
        runcmd git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${syntax_highlighting}"
    fi

    # main
    replace_file "$HOME/.zshrc" "$DF_HOME/files/zshrc"
    replace_file "$HOME/.aliases" "$DF_HOME/files/aliases"
    replace_file "$HOME/.functions" "$DF_HOME/files/functions"
    # custom theme
    replace_file "${ZSH_CUSTOM:-$DEFAULT_ZSH_CUSTOM}/themes/quarter-life.zsh-theme" "$DF_HOME/files/quarter-life.zsh-theme"
}

function install_scripts {
    # link files 1 by 1 to avoid overwriting any other custom stuff in there
    local dir="$HOME/bin"
    mkdir -p "$dir"
    shopt -s nullglob
    for file in "${DF_HOME}"/files/bin/*; do
        fname="$(basename "$file")"
        replace_file "$HOME/bin/$fname" "$DF_HOME/files/bin/$fname"
    done
    shopt -u nullglob
}

function setup_kitty {
    replace_dir "$CONFIG_HOME/kitty" "$DF_HOME/files/kitty"
}

function setup_alacritty {
    replace_dir "$CONFIG_HOME/alacritty" "$DF_HOME/files/alacritty"
}

function setup_ghostty {
    mkdir -p "$CONFIG_HOME/ghostty"
    replace_dir "$CONFIG_HOME/ghostty" "$DF_HOME/files/ghostty"
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
    touch "$HOME/.hushlogin"
    # first install package managers
    install_brew
    install_npm

    # install packages
    install_packages
    install_colorscheme

    # install tools
    install_python
    setup_tmux
    setup_nvim
    install_scripts

    # shell
    setup_zsh

    # terminal
    setup_ghostty

    runcmd source "$HOME/.zshrc"
}

function usage {
    echo "USAGE: source $0 [dev, packages, sketchybar, wezterm, kitty, alacritty, colors]"
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
        "ghostty")
            setup_ghostty
            ;;
        "colors")
            install_colorscheme
            ;;
        "scripts")
            install_scripts
            ;;
        "*")
            usage
            ;;
    esac
done
echo "Done!"
exit 0
