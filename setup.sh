#!/bin/bash

# This is the setup script for my config. The idea is to be able to run
# this after cloning the repo on a Mac or Ubuntu (WSL) system and be up
# and running very quickly.

# create directories
export XDG_CONFIG_HOME="$HOME"/.config
mkdir -p "$XDG_CONFIG_HOME"/zsh
mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"

# Symbolic links
ln -sf "$PWD/.zshrc" "$HOME"/.zshrc
ln -sf "$PWD/.bash_profile" "$HOME"/.bash_profile  # Keep for compatibility
ln -sf "$PWD/.bashrc" "$HOME"/.bashrc  # Keep for compatibility
ln -sf "$PWD/.inputrc" "$HOME"/.inputrc
ln -sf "$PWD/nvim" "$XDG_CONFIG_HOME"/nvim
ln -sf "$PWD/ghostty/config" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
# Note: starship.toml not used with pure prompt in zsh

# notater - use current user's home directory
export NOTES="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/Notes/"
ln -sf "$NOTES" ~/notes

# iCloud - use current user's home directory
export ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
ln -sf "$ICLOUD" ~/icloud

# Global Python tools via pipx (run after brew bundle installs Python)
echo "Installing global Python tools..."
pipx install poetry
