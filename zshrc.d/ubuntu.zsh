# Ubuntu-specific Zsh configuration

# PATH additions
[[ :$PATH: != *":$HOME/.local/bin:"* ]] && export PATH="$HOME/.local/bin:$PATH"

# Platform-specific aliases
if command -v eza &>/dev/null; then
  alias ls='eza --icons'
  alias ll='eza -lah --icons'
  alias la='eza -la --icons'
  alias lt='eza --tree --icons'
else
  alias ll='ls -lAh --color=auto'
fi
