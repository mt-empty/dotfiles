# Utility functions (all platforms)

# Create a directory and cd into it
mkcd() {
  [ -z "$1" ] && { echo "usage: mkcd <dir>"; return 1; }
  mkdir -p "$1" && cd "$1"
}

# Extract any common archive format
extract() {
  [ -f "$1" ] || { echo "extract: file not found: $1"; return 1; }
  case "$1" in
    *.tar.gz|*.tgz) tar xzf "$1" ;;
    *.tar.bz2)      tar xjf "$1" ;;
    *.tar.xz)       tar xJf "$1" ;;
    *.tar)          tar xf  "$1" ;;
    *.zip)          unzip   "$1" ;;
    *.gz)           gunzip  "$1" ;;
    *.bz2)          bunzip2 "$1" ;;
    *.xz)           xz -d   "$1" ;;
    *.7z)           7z x    "$1" ;;
    *) echo "Unknown archive: $1"; return 1 ;;
  esac
}

# Update all available package managers (cross-platform)
up() {
  local _failed=0

  # apt (Linux, requires sudo)
  if command -v apt &>/dev/null; then
    echo "==> apt"
    sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y || _failed=1
  fi

  # flatpak (no sudo needed)
  if command -v flatpak &>/dev/null; then
    echo "==> flatpak"
    flatpak update -y || _failed=1
  fi

  # snap (requires sudo)
  if command -v snap &>/dev/null; then
    echo "==> snap"
    sudo snap refresh || _failed=1
  fi

  # brew (no sudo needed; works on Linux and macOS)
  if command -v brew &>/dev/null; then
    echo "==> brew"
    brew update && brew upgrade || _failed=1
  fi

  return $_failed
}
