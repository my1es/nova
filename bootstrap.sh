#!/bin/bash

PYTHON_VERSION=3.6.7
THIRD="$HOME/third_party"

set -e

install_packages() {
  sudo apt-get install -y \
  git \
  vim \
  vim-gtk \
  tmux \
  cmake \
  build-essential \
  chromium-browser \
  curl \
  net-tools \
  neofetch \
  htop \
  ninja-build \
  yasm \
  libssl-dev \
  zlib1g-dev \
  libncurses5-dev \
  libncursesw5-dev \
  libreadline-dev \
  libsqlite3-dev \
  libdbus-1-dev \
  uuid-dev \
  python3-venv
}

bootstrap_dirs() {
  mkdir -p ~/projects
  mkdir -p $THIRD
}

bootstrap_vim() {
  if [ -d ~/.vim/plugged ]; then 
    echo "Vim-Plug installed already."
    return 0
  fi
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vim -c PlugInstall -c qa
}

install_pyenv() {
  if [ -d $THIRD/.pyenv ]; then 
    echo "Python env already set up."
    return 0
  fi
  python3 -m venv $THIRD/.pyenv
}

install_ripgrep() {
  pushd $THIRD
  if [ -e $THIRD/ripgrep-0.10.0-x86_64-unknown-linux-musl/rg ]; then
    echo "ripgrep exists"
    return
  fi

  wget https://github.com/BurntSushi/ripgrep/releases/download/0.10.0/ripgrep-0.10.0-x86_64-unknown-linux-musl.tar.gz
  tar -xvf ripgrep-0.10.0-x86_64-unknown-linux-musl.tar.gz
  popd
}

install_bar() {
  if [ -d ~/third_party/i3status-rust ]; then
    echo "i3status-rust already installed."
    return 0
  fi

  pushd $THIRD
  git clone https://github.com/greshake/i3status-rust
  cd i3status-rust && cargo build --release
  popd
}

install_alacritty()  {
  pushd $THIRD
  wget https://github.com/jwilm/alacritty/releases/download/v0.2.9/Alacritty-v0.2.9-x86_64.tar.gz
  tar -xvzf Alacritty-v0.2.9-x86_64.tar.gz
  mv alacritty alacritty-0.2.9
  rm Alacritty-v0.2.9-x86_64.tar.gz
  popd
}

install_playerctl() {
  pushd $THIRD
  wget https://github.com/acrisci/playerctl/releases/download/v2.0.1/playerctl-2.0.1_amd64.deb
  sudo dpkg -i playerctl-2.0.1_amd64.deb
  sudo apt-get install -f
  rm playerctl-2.0.1_amd64.deb
  popd
}

install_python_packages() {
  pip install -r requirements.txt
}

bootstrap_dirs
bootstrap_vim
install_packages
install_pyenv
install_ripgrep
install_alacritty
install_bar
install_playerctl
