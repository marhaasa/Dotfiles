#!/bin/bash

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
info() {
  echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
  echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
  echo -e "${RED}[ERROR]${NC} $1"
  exit 1
}

prompt() {
  echo -e "${BLUE}[?]${NC} $1"
}

# Confirm action with user
confirm() {
  local message=$1
  local response
  prompt "$message [y/N]: "
  read -r response
  case "$response" in
  [yY][eE][sS] | [yY]) return 0 ;;
  *) return 1 ;;
  esac
}

# Detect OS
detect_os() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
  else
    error "Unsupported OS: $OSTYPE"
  fi
  info "Detected OS: $OS"
}

# Remove symlink
remove_symlink() {
  local target=$1

  if [[ -L "$target" ]]; then
    rm "$target"
    info "Removed symlink: $target"
  elif [[ -e "$target" ]]; then
    warn "$target exists but is not a symlink, skipping..."
  fi
}

# Remove all backups created by setup script
remove_backups() {
  info "Removing backup files..."

  local backup_files=(
    "$HOME/.zshrc.backup"
    "$HOME/.bash_profile.backup"
    "$HOME/.bashrc.backup"
    "$HOME/.inputrc.backup"
    "$HOME/.ssh/config.backup"
  )

  for backup in "${backup_files[@]}"; do
    if [[ -f "$backup" ]]; then
      rm "$backup"
      info "Removed backup: $backup"
    fi
  done
}

# Remove shell configurations
remove_shell_configs() {
  info "Removing shell configurations..."

  remove_symlink "$HOME/.zshrc"
  remove_symlink "$HOME/.bash_profile"
  remove_symlink "$HOME/.bashrc"
  remove_symlink "$HOME/.inputrc"

  # Remove zsh functions directory symlink
  if [[ -L "$HOME/.zsh_functions" ]]; then
    rm "$HOME/.zsh_functions"
    info "Removed .zsh_functions symlink"
  fi
}

# Remove Neovim configuration
remove_neovim() {
  info "Removing Neovim configuration..."

  if [[ -L "$HOME/.config/nvim" ]]; then
    rm "$HOME/.config/nvim"
    info "Removed Neovim configuration symlink"
  fi

  # Remove Neovim data and cache
  if confirm "Remove Neovim data and plugins?"; then
    rm -rf "$HOME/.local/share/nvim"
    rm -rf "$HOME/.local/state/nvim"
    rm -rf "$HOME/.cache/nvim"
    rm -rf "$HOME/.local/nvim"
    info "Removed Neovim data, state, and cache"
  fi
}

# Remove Ghostty configuration
remove_ghostty() {
  info "Removing Ghostty configuration..."

  if [[ "$OS" == "macos" ]]; then
    local ghostty_config="$HOME/Library/Application Support/com.mitchellh.ghostty/config"
    if [[ -L "$ghostty_config" ]]; then
      rm "$ghostty_config"
      info "Removed Ghostty configuration symlink"
    fi
  fi
}

# Remove macOS-specific configurations
remove_macos_specific() {
  if [[ "$OS" != "macos" ]]; then
    return
  fi

  info "Removing macOS-specific configurations..."

  # Remove notes symlink
  if [[ -L "$HOME/notes" ]]; then
    rm "$HOME/notes"
    info "Removed notes symlink"
  fi

  # Remove iCloud symlink
  if [[ -L "$HOME/icloud" ]]; then
    rm "$HOME/icloud"
    info "Removed iCloud symlink"
  fi

  # Reset dock to defaults
  if confirm "Reset dock to system defaults?"; then
    defaults delete com.apple.dock
    killall Dock
    info "Reset dock to system defaults"
  fi
}

# Remove SSH configuration
remove_ssh_config() {
  info "Checking SSH configuration..."

  local ssh_config="$HOME/.ssh/config"
  if [[ -f "$ssh_config" ]]; then
    # Check if our 1Password config exists
    if grep -q "IdentityAgent.*2BUA8C4S2C.com.1password" "$ssh_config" 2>/dev/null; then
      if confirm "Remove 1Password SSH agent configuration?"; then
        # Remove the Host * block with IdentityAgent
        if [[ "$OS" == "macos" ]]; then
          sed -i '' '/^Host \*$/,/^$/d' "$ssh_config"
        else
          sed -i '/^Host \*$/,/^$/d' "$ssh_config"
        fi

        # If file is now empty, remove it
        if [[ ! -s "$ssh_config" ]]; then
          rm "$ssh_config"
          info "Removed empty SSH config file"
        else
          info "Removed 1Password SSH agent configuration"
        fi
      fi
    fi
  fi
}

# Remove Git configuration
remove_git_config() {
  if confirm "Remove Git user configuration (marhaasa/marius@aasarod.no)?"; then
    local current_name=$(git config --global user.name)
    local current_email=$(git config --global user.email)

    if [[ "$current_name" == "marhaasa" ]] && [[ "$current_email" == "marius@aasarod.no" ]]; then
      git config --global --unset user.name
      git config --global --unset user.email
      info "Removed Git user configuration"
    else
      warn "Git config doesn't match expected values, skipping..."
    fi
  fi
}

# Uninstall packages
uninstall_packages() {
  if [[ "$OS" == "macos" ]] && command -v brew &>/dev/null; then
    if confirm "Uninstall Homebrew packages from Brewfile?"; then
      if [[ -f "Brewfile" ]]; then
        info "Packages that will be removed:"
        brew bundle list --file=Brewfile

        if confirm "Proceed with uninstalling these packages?"; then
          # Generate list of packages to remove
          brew bundle list --file=Brewfile --casks | xargs -I {} brew uninstall --cask {} 2>/dev/null || true
          brew bundle list --file=Brewfile --brews | xargs -I {} brew uninstall {} 2>/dev/null || true

          # Remove taps
          brew untap buo/cask-upgrade 2>/dev/null || true
          brew untap keith/formulae 2>/dev/null || true
          brew untap marhaasa/tools 2>/dev/null || true

          info "Uninstalled Homebrew packages"
        fi
      else
        warn "Brewfile not found, skipping package removal"
      fi
    fi
  fi

  # Remove Python tools
  if command -v pipx &>/dev/null; then
    if pipx list | grep -q poetry; then
      if confirm "Uninstall poetry (installed via pipx)?"; then
        pipx uninstall poetry
        info "Uninstalled poetry"
      fi
    fi
  fi
}

# Remove shell from /etc/shells and reset default shell
reset_shell() {
  if [[ "$OS" == "macos" ]]; then
    local homebrew_zsh="/opt/homebrew/bin/zsh"

    # Remove from /etc/shells
    if grep -q "$homebrew_zsh" /etc/shells 2>/dev/null; then
      if confirm "Remove Homebrew zsh from /etc/shells?"; then
        sudo sed -i '' "\|$homebrew_zsh|d" /etc/shells
        info "Removed $homebrew_zsh from /etc/shells"
      fi
    fi

    # Reset shell to system default
    if [[ "$SHELL" == "$homebrew_zsh" ]] || [[ "$SHELL" == "/bin/zsh" ]]; then
      if confirm "Reset default shell to /bin/bash?"; then
        chsh -s /bin/bash
        info "Changed default shell to /bin/bash"
      fi
    fi
  fi
}

# Clean up directories
cleanup_directories() {
  info "Cleaning up empty directories..."

  # Remove directories if empty
  local dirs=(
    "$HOME/.config/nvim"
    "$HOME/.config/zsh"
    "$HOME/.config/ghostty"
    "$HOME/.zsh_functions"
    "$HOME/.local/bin"
  )

  for dir in "${dirs[@]}"; do
    if [[ -d "$dir" ]] && [[ -z "$(ls -A "$dir" 2>/dev/null)" ]]; then
      rmdir "$dir" 2>/dev/null && info "Removed empty directory: $dir"
    fi
  done

  # Check parent directories
  for parent in "$HOME/.config" "$HOME/.local"; do
    if [[ -d "$parent" ]] && [[ -z "$(ls -A "$parent" 2>/dev/null)" ]]; then
      rmdir "$parent" 2>/dev/null && info "Removed empty directory: $parent"
    fi
  done

  # Remove .ssh directory if only our config was there
  if [[ -d "$HOME/.ssh" ]] && [[ -z "$(ls -A "$HOME/.ssh" 2>/dev/null)" ]]; then
    if confirm "Remove empty .ssh directory?"; then
      rmdir "$HOME/.ssh"
      info "Removed empty .ssh directory"
    fi
  fi
}

# Main uninstall function
main() {
  echo -e "${RED}WARNING: This will remove all dotfiles configurations and return to system defaults${NC}"
  warn "This operation cannot be undone!"

  if ! confirm "Continue with complete uninstall?"; then
    info "Uninstall cancelled"
    exit 0
  fi

  detect_os

  # Core removals
  remove_shell_configs
  remove_neovim
  remove_ghostty
  remove_macos_specific

  # Configuration removals
  remove_ssh_config
  remove_git_config

  # Remove backups
  if confirm "Remove all backup files created by setup.sh?"; then
    remove_backups
  fi

  # Optional removals
  uninstall_packages

  # Reset shell
  reset_shell

  # Final cleanup
  cleanup_directories

  info "Uninstall complete! System returned to defaults."
  info "Please restart your terminal for all changes to take effect."

  if [[ "$OS" == "macos" ]]; then
    info "Your default shell has been reset to /bin/bash"
  fi
}

# Run main function
main "$@"
