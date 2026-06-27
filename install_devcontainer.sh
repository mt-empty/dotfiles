#!/bin/bash
# install_devcontainer.sh — headless dotfiles bootstrap for dev containers
# Skips all GUI, GNOME, Firefox, and interactive steps.
# NOTE: This script is Linux/devcontainer only. Do not run on macOS.
set -e

[ "$(uname)" = "Linux" ] || { echo "ERROR: this script is for Linux containers only."; exit 1; }

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$HOME"

# Helper: create symlink with logging. Backs up any real file before replacing it.
lnk() {
    if [ -e "$2" ] && [ ! -L "$2" ]; then
        BACKUP="$2.bak.$(date +%s%N)"
        echo "  WARNING: backing up existing file $2 → $BACKUP"
        mv "$2" "$BACKUP"
    fi
    echo "  symlink: $1 → $2"
    ln -sfn "$1" "$2"
}
lnkd() {
    if [ -e "$2" ] && [ ! -L "$2" ]; then
        BACKUP="$2.bak.$(date +%s%N)"
        echo "  WARNING: backing up existing path $2 → $BACKUP"
        mv "$2" "$BACKUP"
    fi
    echo "  symlink: $1/ → $2/"
    ln -snf "$1" "$2"
}

echo ">>> Linking dotfiles..."
lnk "$DOTFILES_DIR/.zshrc"       .zshrc
lnk "$DOTFILES_DIR/.vimrc"       .vimrc
lnk "$DOTFILES_DIR/.inputrc"     .inputrc
lnk "$DOTFILES_DIR/.gitconfig"   .gitconfig
lnkd "$DOTFILES_DIR/.config/tmux" "$HOME/.config/tmux"
lnk "$DOTFILES_DIR/.fzf.zsh"     .fzf.zsh
mkdir -p "$HOME/.config/bat"
lnk "$DOTFILES_DIR/.config/bat/config" "$HOME/.config/bat/config"
lnkd "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"

# MCP config
lnk "$DOTFILES_DIR/.config/agent/mcp.json" "$HOME/.claude.json"

# VS Code user settings (makes dotfiles.repository + dotfiles.installCommand active on the host)
mkdir -p "$HOME/.config/Code/User"
lnk "$DOTFILES_DIR/.config/vscode/settings.json" "$HOME/.config/Code/User/settings.json"
lnk "$DOTFILES_DIR/.config/vscode/keybindings.json" "$HOME/.config/Code/User/keybindings.json"

# CLI tool configs
mkdir -p "$HOME/.config/ripgrep"
lnk "$DOTFILES_DIR/.config/ripgrep/config" "$HOME/.config/ripgrep/config"
mkdir -p "$HOME/.config/fd"
lnk "$DOTFILES_DIR/.config/fd/config" "$HOME/.config/fd/config"
mkdir -p "$HOME/.config/tealdeer"
lnk "$DOTFILES_DIR/.config/tealdeer/config.toml" "$HOME/.config/tealdeer/config.toml"
lnk "$DOTFILES_DIR/.config/curl/config" "$HOME/.curlrc"

# pnpm
mkdir -p "$HOME/.config/pnpm"
lnk "$DOTFILES_DIR/.config/pnpm/rc" "$HOME/.config/pnpm/rc"

# uv (Python environment manager)
mkdir -p "$HOME/.config/uv"
lnk "$DOTFILES_DIR/.config/uv/uv.toml" "$HOME/.config/uv/uv.toml"

# Podman rootless
mkdir -p "$HOME/.config/containers"
lnk "$DOTFILES_DIR/.config/containers/containers.conf" "$HOME/.config/containers/containers.conf"

# Rust/Cargo
mkdir -p "$HOME/.cargo"
lnk "$DOTFILES_DIR/.cargo/config.toml" "$HOME/.cargo/config.toml"

# Symlink zshrc.d directory
lnkd "$DOTFILES_DIR/zshrc.d" "$HOME/zshrc.d"

# Oh My Zsh install (unattended)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo ">>> Installing Oh My Zsh..."
    # Ensure zsh is available — many base images don't include it
    if ! command -v zsh &>/dev/null; then
        echo ">>> zsh not found, installing..."
        if command -v sudo &>/dev/null; then
            sudo apt-get update -y && sudo apt-get install -y zsh
        else
            apt-get update -y && apt-get install -y zsh
        fi
    fi
    OMZSCRIPT=$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) \
      || { echo "ERROR: Failed to download Oh My Zsh installer"; exit 1; }
    [ -n "$OMZSCRIPT" ] || { echo "ERROR: Oh My Zsh installer download returned empty"; exit 1; }
    sh -c "$OMZSCRIPT" "" --unattended || { echo "ERROR: Oh My Zsh installer failed"; exit 1; }
    # OMZ's setup_zshrc() moves .zshrc aside and writes its template; restore ours.
    lnk "$DOTFILES_DIR/.zshrc" .zshrc
fi

# Install Oh My Zsh community plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ -d "$HOME/.oh-my-zsh" ]; then
  if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
  fi
  if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
  fi
fi

echo ">>> Dotfiles container bootstrap complete."
