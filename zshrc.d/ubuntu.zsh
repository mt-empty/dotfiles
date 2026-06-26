# Ubuntu-specific Zsh configuration

# PATH additions
[[ :$PATH: != *":$HOME/.local/bin:"* ]] && export PATH="$HOME/.local/bin:$PATH"

# Platform-specific aliases
alias ll='ls -lAh --color=auto'
