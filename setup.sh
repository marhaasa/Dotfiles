#!/bin/bash

# This is the setup script for my config. The idea is to be able to run
# this after cloning the repo on a Mac or Ubuntu (WSL) system and be up
# and running very quickly.

# create directories
export XDG_CONFIG_HOME="$HOME"/.config
mkdir -p "$XDG_CONFIG_HOME"/zsh

# Symbolic links
ln -sf "$PWD/.zshrc" "$HOME"/.zshrc
ln -sf "$PWD/.bash_profile" "$HOME"/.bash_profile  # Keep for compatibility
ln -sf "$PWD/.bashrc" "$HOME"/.bashrc  # Keep for compatibility
ln -sf "$PWD/.inputrc" "$HOME"/.inputrc
ln -sf "$PWD/nvim" "$XDG_CONFIG_HOME"/nvim
# Note: starship.toml not used with pure prompt in zsh

# notater - use current user's home directory
export NOTES="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/Notes/"
ln -sf "$NOTES" ~/notes

# iCloud - use current user's home directory
export ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
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
