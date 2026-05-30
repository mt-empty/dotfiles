#!/bin/bash
# install_devcontainer.sh — headless dotfiles bootstrap for dev containers
# Skips all GUI, GNOME, Firefox, and interactive steps.
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$HOME"

# Helper: create symlink with logging
lnk()  { echo "  symlink: $1 → $2"; ln -sf  "$1" "$2"; }
lnkd() { echo "  symlink: $1/ → $2/"; ln -snf "$1" "$2"; }

echo ">>> Linking dotfiles..."
lnk "$DOTFILES_DIR/.zshrc"       .zshrc
lnk "$DOTFILES_DIR/.vimrc"       .vimrc
lnk "$DOTFILES_DIR/.gitconfig"   .gitconfig
lnk "$DOTFILES_DIR/.tmux.conf"   .tmux.conf
lnk "$DOTFILES_DIR/.fzf.zsh"     .fzf.zsh
lnk "$DOTFILES_DIR/.bat.conf"    .bat.conf
lnk "$DOTFILES_DIR/.lazygit.yml" .lazygit.yml

# Claude global config
lnk "$DOTFILES_DIR/.claude.json" .claude.json
mkdir -p "$HOME/.claude"
lnk "$DOTFILES_DIR/.config/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

# Symlink zshrc.d directory
lnkd "$DOTFILES_DIR/zshrc.d" "$HOME/zshrc.d"

# Oh My Zsh install (unattended)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo ">>> Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

echo ">>> Dotfiles container bootstrap complete."
