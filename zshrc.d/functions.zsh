# Utility functions (all platforms)

# Create a directory and cd into it
mkcd() { mkdir -p "$1" && cd "$1"; }

# Extract any common archive format
extract() {
  case "$1" in
    *.tar.gz|*.tgz) tar xzf "$1" ;;
    *.tar.bz2)      tar xjf "$1" ;;
    *.tar.xz)       tar xJf "$1" ;;
    *.tar)          tar xf  "$1" ;;
    *.zip)          unzip   "$1" ;;
    *.gz)           gunzip  "$1" ;;
    *.bz2)          bunzip2 "$1" ;;
    *.xz)           unxz    "$1" ;;
    *.7z)           7z x    "$1" ;;
    *) echo "Unknown archive: $1" ;;
  esac
}

# Update all available package managers (cross-platform)
up() {
  # apt (Linux, requires sudo)
  if command -v apt &>/dev/null; then
    echo "==> apt"
    sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
  fi

  # flatpak (no sudo needed)
  if command -v flatpak &>/dev/null; then
    echo "==> flatpak"
    flatpak update -y
  fi

  # snap (requires sudo)
  if command -v snap &>/dev/null; then
    echo "==> snap"
    sudo snap refresh
  fi

  # brew (no sudo needed; works on Linux and macOS)
  if command -v brew &>/dev/null; then
    echo "==> brew"
    brew update && brew upgrade
  fi
}
