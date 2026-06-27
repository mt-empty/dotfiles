#!/bin/bash
set -eo pipefail


OS="$(uname)"
PACKAGES=(git zsh vim neovim fzf gh tealdeer acli firefox kiro inav tmux ripgrep bat eza lazygit z fd curl wget jq htop tree node pnpm python3 uv docker podman gpg ssh)

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
    # Tools with standalone Linux installers
    if [[ "$PKG" == "uv" ]]; then
      curl -LsSf https://astral.sh/uv/install.sh | sh || echo "WARNING: failed to install uv"
      continue
    fi
    if [[ "$PKG" == "pnpm" ]]; then
      if command -v npm &>/dev/null; then
        npm install -g pnpm || echo "WARNING: failed to install pnpm"
      else
        curl -fsSL https://get.pnpm.io/install.sh | sh - || echo "WARNING: failed to install pnpm"
      fi
      continue
    fi
    APT_PKG="$PKG"
    [[ "$PKG" == "node" ]] && APT_PKG="nodejs"
    [[ "$PKG" == "docker" ]] && APT_PKG="docker.io"
    sudo apt install -y "$APT_PKG" || echo "WARNING: failed to install $APT_PKG, continuing..."
  fi
done

echo "Package installation complete."
