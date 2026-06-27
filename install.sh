#!/bin/bash
set -e

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

# Symlink dotfiles
echo "Linking dotfiles..."
lnk "$DOTFILES_DIR/.zshrc" .zshrc
lnk "$DOTFILES_DIR/.vimrc" .vimrc
lnk "$DOTFILES_DIR/.inputrc" .inputrc
lnk "$DOTFILES_DIR/.gitconfig" .gitconfig
lnkd "$DOTFILES_DIR/.config/tmux" "$HOME/.config/tmux"
lnk "$DOTFILES_DIR/.fzf.zsh" .fzf.zsh
mkdir -p "$HOME/.config/bat"
lnk "$DOTFILES_DIR/.config/bat/config" "$HOME/.config/bat/config"
mkdir -p "$HOME/.config/lazygit"
lnk "$DOTFILES_DIR/.config/lazygit/config.yml" "$HOME/.config/lazygit/config.yml"
lnkd "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"

# Symlink app configs under .config/
mkdir -p "$HOME/.config/ghostty"
lnk "$DOTFILES_DIR/.config/ghostty/config" "$HOME/.config/ghostty/config"

# MCP config (shared across tools)
lnk "$DOTFILES_DIR/.config/agent/mcp.json" "$HOME/.claude.json"
mkdir -p "$HOME/.kiro/settings"
lnk "$DOTFILES_DIR/.config/agent/mcp.json" "$HOME/.kiro/settings/mcp.json"

# VS Code / GitHub Copilot global MCP and instructions
VSCODE_USER_DIR="$HOME/.config/Code/User"
mkdir -p "$VSCODE_USER_DIR/prompts"
lnk "$DOTFILES_DIR/.config/vscode/settings.json" "$VSCODE_USER_DIR/settings.json"
lnk "$DOTFILES_DIR/.config/vscode/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"
lnk "$DOTFILES_DIR/.config/vscode/mcp.json" "$VSCODE_USER_DIR/mcp.json"
lnk "$DOTFILES_DIR/.config/vscode/prompts/agent-browser.instructions.md" "$VSCODE_USER_DIR/prompts/agent-browser.instructions.md"

# Zed editor
mkdir -p "$HOME/.config/zed"
lnk "$DOTFILES_DIR/.config/zed/settings.json" "$HOME/.config/zed/settings.json"
lnk "$DOTFILES_DIR/.config/zed/keymap.json" "$HOME/.config/zed/keymap.json"

# CLI tool configs
mkdir -p "$HOME/.config/ripgrep"
lnk "$DOTFILES_DIR/.config/ripgrep/config" "$HOME/.config/ripgrep/config"
mkdir -p "$HOME/.config/fd"
lnk "$DOTFILES_DIR/.config/fd/config" "$HOME/.config/fd/config"
mkdir -p "$HOME/.config/tealdeer"
lnk "$DOTFILES_DIR/.config/tealdeer/config.toml" "$HOME/.config/tealdeer/config.toml"
lnk "$DOTFILES_DIR/.config/curl/config" "$HOME/.curlrc"

# gh CLI
mkdir -p "$HOME/.config/gh"
lnk "$DOTFILES_DIR/.config/gh/config.yml" "$HOME/.config/gh/config.yml"

# SSH
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
chmod 600 "$DOTFILES_DIR/.ssh/config"
lnk "$DOTFILES_DIR/.ssh/config" "$HOME/.ssh/config"

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

# Install ghostty-quake toggle script
mkdir -p "$HOME/.local/bin"
lnk "$DOTFILES_DIR/.local/bin/ghostty-quake" "$HOME/.local/bin/ghostty-quake"
chmod +x "$DOTFILES_DIR/.local/bin/ghostty-quake"

# Register Ctrl+Escape as GNOME custom shortcut for ghostty-quake (GNOME only)
if command -v dconf > /dev/null && [ -n "${DBUS_SESSION_BUS_ADDRESS-}" ] && [[ "${XDG_CURRENT_DESKTOP:-}" =~ [Gg][Nn][Oo][Mm][Ee] ]]; then
  KBASE="/org/gnome/settings-daemon/plugins/media-keys"
  KPATH="${KBASE}/custom-keybindings/custom-ghostty/"
  # Read existing list and append our entry if not already present
  EXISTING=$(dconf read "${KBASE}/custom-keybindings" 2>/dev/null)
  [ -n "$EXISTING" ] || EXISTING="[]"
  if ! echo "$EXISTING" | grep -q "custom-ghostty"; then
    NEW_LIST=$(echo "$EXISTING" | sed "s|]$|, '${KPATH}']|" | sed "s|\[, |[|")
    [ "$NEW_LIST" = "[]" ] && NEW_LIST="['${KPATH}']"
    dconf write "${KBASE}/custom-keybindings" "$NEW_LIST" || echo "WARNING: Failed to update GNOME keybindings list"
  fi
  dconf write "${KPATH}name" "'Ghostty Quake'" || echo "WARNING: Failed to write GNOME shortcut name"
  dconf write "${KPATH}command" "'$HOME/.local/bin/ghostty-quake'" || echo "WARNING: Failed to write GNOME shortcut command"
  dconf write "${KPATH}binding" "'<Control>Escape'" || echo "WARNING: Failed to write GNOME shortcut binding"
  echo "GNOME shortcut registered: Ctrl+Escape → ghostty-quake"
fi

# Symlink zshrc.d directory
lnkd "$DOTFILES_DIR/zshrc.d" "$HOME/zshrc.d"

# Oh My Zsh install
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  OMZSCRIPT=$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) \
    || { echo "ERROR: Failed to download Oh My Zsh installer"; exit 1; }
  [ -n "$OMZSCRIPT" ] || { echo "ERROR: Oh My Zsh installer download returned empty"; exit 1; }
  sh -c "$OMZSCRIPT" "" --unattended || { echo "ERROR: Oh My Zsh installer failed"; exit 1; }
  # OMZ's setup_zshrc() moves .zshrc aside and writes its template; restore ours.
  lnk "$DOTFILES_DIR/.zshrc" .zshrc
fi

# Set Zsh as default shell
if [ "$(basename "$SHELL")" != "zsh" ]; then
  chsh -s "$(command -v zsh)" || echo "WARNING: chsh failed — set your shell to zsh manually."
  echo "Default shell changed to Zsh. Please restart your terminal."
fi

# Firefox configuration
read -rp "Apply Firefox user.js settings? [y/N] " apply_firefox
if [[ "$apply_firefox" =~ ^[Yy]$ ]]; then
  bash "$DOTFILES_DIR/install_firefox.sh"
fi

echo "Dotfiles installation complete."
