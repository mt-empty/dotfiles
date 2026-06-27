# macOS-specific Zsh configuration

# Homebrew
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Platform-specific aliases
if command -v eza &>/dev/null; then
  alias ls='eza --icons'
  alias ll='eza -lah --icons'
  alias la='eza -la --icons'
  alias lt='eza --tree --icons'
else
  alias ll='ls -lAhG'
fi
