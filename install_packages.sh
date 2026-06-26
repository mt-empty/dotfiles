#!/bin/bash
set -e


OS="$(uname)"
PACKAGES=(git zsh vim neovim fzf gh tealdeer acli firefox kiro inav tmux ripgrep bat exa lazygit z fd curl wget jq htop tree node python3 docker gpg ssh)

if [[ "$OS" == "Darwin" ]]; then
  MANAGER="brew"
  if ! command -v brew &>/dev/null; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
elif [[ "$OS" == "Linux" ]]; then
  MANAGER="apt"
  sudo apt update || echo "WARNING: apt update failed, package list may be stale"
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
  if ! [[ "$i" =~ ^[0-9]+$ ]] || (( i < 1 || i > ${#PACKAGES[@]} )); then
    echo "Skipping invalid selection: $i (must be 1-${#PACKAGES[@]})"
    continue
  fi
  PKG="${PACKAGES[$((i-1))]}"
  echo "Installing $PKG..."
  if [[ "$MANAGER" == "brew" ]]; then
    brew install "$PKG" || echo "WARNING: failed to install $PKG, continuing..."
  else
    APT_PKG="$PKG"
    [[ "$PKG" == "node" ]] && APT_PKG="nodejs"
    [[ "$PKG" == "docker" ]] && APT_PKG="docker.io"
    sudo apt install -y "$APT_PKG" || echo "WARNING: failed to install $APT_PKG, continuing..."
  fi
done

echo "Package installation complete."
