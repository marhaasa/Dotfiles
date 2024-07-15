#!/bin/bash

# This is the setup script for my config. The idea is to be able to run
# this after cloning the repo on a Mac or Ubuntu (WSL) system and be up
# and running very quickly.

# create directories
export XDG_CONFIG_HOME="$HOME"/.config
mkdir -p "$XDG_CONFIG_HOME"/bash
mkdir -p "$XDG_CONFIG_HOME"/alacritty
mkdir -p "$XDG_CONFIG_HOME"/alacritty/themes
mkdir -p "$XDG_CONFIG_HOME"/skhd
mkdir -p "$XDG_CONFIG_HOME"/k9s

# git clone https://github.com/alacritty/alacritty-theme "$XDG_CONFIG_HOME"/alacritty/themes

# Symbolic links

# ln -s ./.amethyst.yml "$HOME"/.amethyst.yml
ln -sf "$PWD/alacritty.toml" "$XDG_CONFIG_HOME"/alacritty/alacritty.toml
ln -sf "$PWD/k9s/skin.yml" "$XDG_CONFIG_HOME"/k9s/skin.yml
ln -sf "$PWD/.bash_profile" "$HOME"/.bash_profile
ln -sf "$PWD/.bashrc" "$HOME"/.bashrc
ln -sf "$PWD/.inputrc" "$HOME"/.inputrc
ln -sf "$PWD/.tmux.conf" "$HOME"/.tmux.conf
ln -sf "$PWD/nvim" "$XDG_CONFIG_HOME"/nvim
ln -sf "$PWD/skhdrc" "$XDG_CONFIG_HOME"/skhd/skhdrc
ln -sf "$PWD/sway" "$XDG_CONFIG_HOME/sway"

# notater
export NOTES=("/users/mariushogliaasarod/Library/Mobile Documents/iCloud~md~obsidian/Documents/Notes/")
ln -sf "$NOTES" ~/notes

# iCloud
export ICLOUD=("/Users/mariushogliaasarod/Library/Mobile Documents/com~apple~CloudDocs")
ln -sf "$ICLOUD" ~/icloud

# Packages

# install brew
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# get the font out of the way first, it's the most annoying
#
# install for Mac using brew. For ubuntu:

# mkdir -p $HOME/.local/share/fonts
# cp $PWD/fonts/UbuntuMono* $HOME/.local/share/fonts

# brew packages Mac
# amethyst fzf nvim exa hugo bash-completion@2 newsboat kubectl starship
# brew install --cask alacritty

# ubuntu packages apt
# sudo apt install ripgrep gh

# ubuntu apt neovim setup
# sudo apt install gcc g++ unzip

# ubuntu brew for vim and neovim setup
# sudo apt install fd fzf kubectl kubectx derailed/k9s/k9s starship

# ubuntu brew for neovim setup
# brew install neovim go lazygit

# ubuntu specific notes
# create symbolic link to neovim from vim when not using neovim on
# Ubuntu systems, because I use the v alias everywhere.
# sudo ln -sf /usr/bin/vim /usr/bin/nvim
#

# Fedora

# brew install fd fzf ripgrep

# /usr/bin/python3 -m pip install pynvim
