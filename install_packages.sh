#!/bin/bash
set -e


OS="$(uname)"
PACKAGES=(git zsh vim neovim fzf gh tealdear acli firefox kiro inav tmux ripgrep bat exa lazygit z fd curl wget jq htop tree node python3 docker gpg ssh)

if [[ "$OS" == "Darwin" ]]; then
  MANAGER="brew"
  if ! command -v brew &>/dev/null; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
elif [[ "$OS" == "Linux" ]]; then
  MANAGER="apt"
  sudo apt update
else
  echo "Unsupported OS: $OS"
  exit 1
fi

echo "Select packages to install (space-separated numbers):"
for i in "${!PACKAGES[@]}"; do
  echo "$((i+1)). ${PACKAGES[$i]}"
done
read -rp "Enter selection: " SELECTION

for i in $SELECTION; do
  PKG="${PACKAGES[$((i-1))]}"
  echo "Installing $PKG..."
  if [[ "$MANAGER" == "brew" ]]; then
    brew install "$PKG"
  else
    sudo apt install -y "$PKG"
  fi
done

echo "Package installation complete."
