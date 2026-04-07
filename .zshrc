# Main Zsh configuration
export DOTFILES="$HOME/.dotfiles"

# Source platform-specific config
if [[ "$OSTYPE" == "darwin"* ]]; then
  source "$DOTFILES/zshrc.d/macos.zsh"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  source "$DOTFILES/zshrc.d/ubuntu.zsh"
fi

# Source local overrides if present
if [[ -f "$DOTFILES/.zshrc.local" ]]; then
  source "$DOTFILES/.zshrc.local"
fi

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
if [ -d "$ZSH" ]; then
  source "$ZSH/oh-my-zsh.sh"
fi
