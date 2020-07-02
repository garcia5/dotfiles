#!/bin/bash

export CONFIG_HOME=$HOME/.config/
export NVIM_HOME=$HOME/.config/nvim

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

function setup_bash {
  ln -s "./files/.bashrc" "$HOME/.bashrc"
}

function setup_nvim {
  ln -s "./files/init.vim" "$NVIM_HOME/init.vim"
}

function setup_tmux {
  ln -s "./files/.tmux.conf" "$HOME/.tmux.conf"
}

function setup_vim {
  ln -s "./files/.vimrc" "$HOME/.vimrc"
}

function setup_zsh {
  ln -s "./files/.zshrc" "$HOME/.zshrc"
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
