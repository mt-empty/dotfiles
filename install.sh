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
