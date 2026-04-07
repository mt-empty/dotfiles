#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$HOME"

# Symlink dotfiles
ln -sf "$DOTFILES_DIR/.zshrc" .zshrc
ln -sf "$DOTFILES_DIR/.vimrc" .vimrc
ln -sf "$DOTFILES_DIR/.gitconfig" .gitconfig
ln -sf "$DOTFILES_DIR/.tmux.conf" .tmux.conf
ln -sf "$DOTFILES_DIR/.fzf.zsh" .fzf.zsh
ln -sf "$DOTFILES_DIR/.bat.conf" .bat.conf
ln -sf "$DOTFILES_DIR/.lazygit.yml" .lazygit.yml

# Symlink app configs under .config/
mkdir -p "$HOME/.config/ghostty"
ln -sf "$DOTFILES_DIR/.config/ghostty/config" "$HOME/.config/ghostty/config"

# Install ghostty-quake toggle script
mkdir -p "$HOME/.local/bin"
ln -sf "$DOTFILES_DIR/.local/bin/ghostty-quake" "$HOME/.local/bin/ghostty-quake"
chmod +x "$DOTFILES_DIR/.local/bin/ghostty-quake"

# Register Ctrl+Escape as GNOME custom shortcut for ghostty-quake (GNOME only)
if command -v dconf > /dev/null && [ -n "${DBUS_SESSION_BUS_ADDRESS-}" ]; then
  KBASE="/org/gnome/settings-daemon/plugins/media-keys"
  KPATH="${KBASE}/custom-keybindings/custom-ghostty/"
  # Read existing list and append our entry if not already present
  EXISTING=$(dconf read "${KBASE}/custom-keybindings" 2>/dev/null || echo "[]")
  if ! echo "$EXISTING" | grep -q "custom-ghostty"; then
    NEW_LIST=$(echo "$EXISTING" | sed "s|]$|, '${KPATH}']|" | sed "s|\[, |[|")
    [ "$NEW_LIST" = "[]" ] && NEW_LIST="['${KPATH}']"
    dconf write "${KBASE}/custom-keybindings" "$NEW_LIST"
  fi
  dconf write "${KPATH}name" "'Ghostty Quake'"
  dconf write "${KPATH}command" "'$HOME/.local/bin/ghostty-quake'"
  dconf write "${KPATH}binding" "'<Control>Escape'"
  echo "GNOME shortcut registered: Ctrl+Escape → ghostty-quake"
fi

# Symlink zshrc.d directory
ln -snf "$DOTFILES_DIR/zshrc.d" "$HOME/zshrc.d"

# Oh My Zsh install
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Set Zsh as default shell
if [ "$SHELL" != "$(command -v zsh)" ]; then
  chsh -s "$(command -v zsh)"
  echo "Default shell changed to Zsh. Please restart your terminal."
fi

# Firefox configuration
read -rp "Apply Firefox user.js settings? [y/N] " apply_firefox
if [[ "$apply_firefox" =~ ^[Yy]$ ]]; then
  bash "$DOTFILES_DIR/install_firefox.sh"
fi

echo "Dotfiles installation complete."
