#!/bin/bash
set -eo pipefail


OS="$(uname)"
PACKAGES=(git zsh neovim fzf gh tealdeer firefox kiro inav tmux ripgrep bat eza btop zoxide fd curl wget jq tree pnpm python3 uv docker podman gpg ssh fnm difftastic rust starship delta dust)

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

  # rust: always use rustup (works on both platforms)
  if [[ "$PKG" == "rust" ]]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y || echo "WARNING: failed to install rust"
    continue
  fi

  if [[ "$MANAGER" == "brew" ]]; then
    BREW_PKG="$PKG"
    [[ "$PKG" == "delta" ]] && BREW_PKG="git-delta"
    brew install "$BREW_PKG" || echo "WARNING: failed to install $PKG, continuing..."
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
    if [[ "$PKG" == "zoxide" ]]; then
      curl -sSfL https://setup.zoxide.dev | sh || echo "WARNING: failed to install zoxide"
      continue
    fi
    if [[ "$PKG" == "fnm" ]]; then
      curl -fsSL https://fnm.vercel.app/install | bash || echo "WARNING: failed to install fnm"
      continue
    fi
    if [[ "$PKG" == "difftastic" ]]; then
      arch="$(uname -m)"
      latest_url="$(
        curl -fsSL https://api.github.com/repos/Wilfred/difftastic/releases/latest \
        | grep browser_download_url \
        | grep "${arch}-unknown-linux-gnu.tar.gz" \
        | cut -d '"' -f 4
      )"
      tmpdir="$(mktemp -d)"
      curl -fsSL "$latest_url" -o "$tmpdir/difft.tar.gz"
      tar -xzf "$tmpdir/difft.tar.gz" -C "$tmpdir"
      sudo install -m 755 "$tmpdir/difft" /usr/local/bin/difft
      rm -rf "$tmpdir"
      continue
    fi
    if [[ "$PKG" == "starship" ]]; then
      curl -sS https://starship.rs/install.sh | sh -s -- --yes || echo "WARNING: failed to install starship"
      continue
    fi
    if [[ "$PKG" == "delta" ]]; then
      arch="$(uname -m)"
      latest_url="$(
        curl -fsSL https://api.github.com/repos/dandavison/delta/releases/latest \
        | grep browser_download_url \
        | grep "${arch}-unknown-linux-gnu.tar.gz" \
        | cut -d '"' -f 4
      )"
      tmpdir="$(mktemp -d)"
      curl -fsSL "$latest_url" -o "$tmpdir/delta.tar.gz"
      tar -xzf "$tmpdir/delta.tar.gz" -C "$tmpdir"
      find "$tmpdir" -name "delta" -type f -exec sudo install -m 755 {} /usr/local/bin/delta \;
      rm -rf "$tmpdir"
      continue
    fi
    if [[ "$PKG" == "dust" ]]; then
      arch="$(uname -m)"
      latest_url="$(
        curl -fsSL https://api.github.com/repos/bootandy/dust/releases/latest \
        | grep browser_download_url \
        | grep "${arch}-unknown-linux-musl.tar.gz" \
        | cut -d '"' -f 4
      )"
      tmpdir="$(mktemp -d)"
      curl -fsSL "$latest_url" -o "$tmpdir/dust.tar.gz"
      tar -xzf "$tmpdir/dust.tar.gz" -C "$tmpdir"
      find "$tmpdir" -name "dust" -type f -exec sudo install -m 755 {} /usr/local/bin/dust \;
      rm -rf "$tmpdir"
      continue
    fi
    APT_PKG="$PKG"
    [[ "$PKG" == "docker" ]] && APT_PKG="docker.io"
    sudo apt install -y "$APT_PKG" || echo "WARNING: failed to install $APT_PKG, continuing..."
  fi
done

echo "Package installation complete."
