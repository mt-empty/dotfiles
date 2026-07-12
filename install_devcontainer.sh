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
    mkdir -p "$(dirname "$2")"
    echo "  symlink: $1/ → $2/"
    ln -snf "$1" "$2"
}

echo ">>> Linking dotfiles..."
lnk "$DOTFILES_DIR/.zshrc"       .zshrc
lnk "$DOTFILES_DIR/.vimrc"       .vimrc
lnk "$DOTFILES_DIR/.inputrc"     .inputrc

# .gitconfig defers identity to the git-ignored ~/.gitconfig.local (see
# [include] below) so no name/email/key ever lands in this tracked repo. On a
# devcontainer, VS Code auto-mounts the host's ~/.gitconfig before this script
# runs, so harvest identity from it here — before the symlink below replaces
# it — rather than requiring it to be set up by hand on every fresh container.
if [ ! -f "$HOME/.gitconfig.local" ] && [ -f "$HOME/.gitconfig" ]; then
    existing_name="$(git config -f "$HOME/.gitconfig" --get user.name 2>/dev/null || true)"
    existing_email="$(git config -f "$HOME/.gitconfig" --get user.email 2>/dev/null || true)"
    if [ -n "$existing_name" ] && [ -n "$existing_email" ]; then
        echo ">>> Seeding ~/.gitconfig.local from existing git identity ($existing_name <$existing_email>)"
        {
            echo "[user]"
            echo "    name = $existing_name"
            echo "    email = $existing_email"
        } > "$HOME/.gitconfig.local"
    fi
fi
lnk "$DOTFILES_DIR/.gitconfig"   .gitconfig
lnkd "$DOTFILES_DIR/.config/tmux" "$HOME/.config/tmux"
lnk "$DOTFILES_DIR/.fzf.zsh"     .fzf.zsh
mkdir -p "$HOME/.config/bat"
lnk "$DOTFILES_DIR/.config/bat/config" "$HOME/.config/bat/config"
lnkd "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"

# Claude Code user settings
mkdir -p "$HOME/.claude"
lnk "$DOTFILES_DIR/.config/claude/settings.json" "$HOME/.claude/settings.json"

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

# nvim (git core.editor in .gitconfig — install if missing)
if ! command -v nvim &>/dev/null; then
    echo ">>> Installing neovim..."
    if command -v sudo &>/dev/null; then
        sudo apt-get update -y && sudo apt-get install -y neovim
    else
        apt-get update -y && apt-get install -y neovim
    fi
fi

# gpg (commit.gpgsign in .gitconfig — install if missing)
if ! command -v gpg &>/dev/null; then
    echo ">>> Installing gnupg..."
    if command -v sudo &>/dev/null; then
        sudo apt-get update -y && sudo apt-get install -y gnupg
    else
        apt-get update -y && apt-get install -y gnupg
    fi
fi

# difft (git diff.external in .gitconfig — install if missing)
if ! command -v difft &>/dev/null; then
    echo ">>> Installing difftastic..."
    arch="$(uname -m)"
    latest_url="$(
        curl -fsSL https://api.github.com/repos/Wilfred/difftastic/releases/latest \
        | grep browser_download_url \
        | grep "${arch}-unknown-linux-gnu.tar.gz" \
        | cut -d '"' -f 4
    )"
    if [ -n "$latest_url" ]; then
        tmpdir="$(mktemp -d)"
        curl -fsSL "$latest_url" -o "$tmpdir/difft.tar.gz"
        tar -xzf "$tmpdir/difft.tar.gz" -C "$tmpdir"
        sudo install -m 755 "$tmpdir/difft" /usr/local/bin/difft
        rm -rf "$tmpdir"
    else
        echo "WARNING: could not resolve difft download URL (GitHub API rate limit?)"
    fi
fi

# delta (git pager referenced by .gitconfig — install if missing)
if ! command -v delta &>/dev/null; then
    echo ">>> Installing delta..."
    arch="$(uname -m)"
    latest_url="$(
        curl -fsSL https://api.github.com/repos/dandavison/delta/releases/latest \
        | grep browser_download_url \
        | grep "${arch}-unknown-linux-gnu.tar.gz" \
        | cut -d '"' -f 4
    )"
    if [ -n "$latest_url" ]; then
        tmpdir="$(mktemp -d)"
        curl -fsSL "$latest_url" -o "$tmpdir/delta.tar.gz"
        tar -xzf "$tmpdir/delta.tar.gz" -C "$tmpdir"
        find "$tmpdir" -name "delta" -type f -exec sudo install -m 755 {} /usr/local/bin/delta \;
        rm -rf "$tmpdir"
    else
        echo "WARNING: could not resolve delta download URL (GitHub API rate limit?)"
    fi
fi

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
