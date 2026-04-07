# macOS-specific Zsh configuration

# Homebrew
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Platform-specific aliases
alias ll='ls -lAhG'  # -G for colour on macOS (no --color=auto)
