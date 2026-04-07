# Main Zsh configuration
export DOTFILES="$HOME/.dotfiles"

# History
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS SHARE_HISTORY

# Source platform-specific config
if [[ "$OSTYPE" == "darwin"* ]]; then
  source "$DOTFILES/zshrc.d/macos.zsh"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  source "$DOTFILES/zshrc.d/ubuntu.zsh"
fi

# Source shared aliases and functions
source "$DOTFILES/zshrc.d/aliases.zsh"
source "$DOTFILES/zshrc.d/functions.zsh"

# Source local overrides if present
if [[ -f "$DOTFILES/.zshrc.local" ]]; then
  source "$DOTFILES/.zshrc.local"
fi

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
plugins=(git z fzf)
if [ -d "$ZSH" ]; then
  source "$ZSH/oh-my-zsh.sh"
fi


