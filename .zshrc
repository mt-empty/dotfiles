# Main Zsh configuration
# Resolve the dotfiles repo location from this file's symlink
export DOTFILES="${${(%):-%x}:A:h}"

# History
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS SHARE_HISTORY

# Oh My Zsh — load first so user aliases/functions defined below override OMZ defaults
export ZSH="$HOME/.oh-my-zsh"
plugins=(git z fzf)
if [ -d "$ZSH" ]; then
  source "$ZSH/oh-my-zsh.sh"
fi

# Source platform-specific config
if [[ "$OSTYPE" == "darwin"* ]]; then
  source "$DOTFILES/zshrc.d/macos.zsh"
elif [[ "$OSTYPE" == linux* ]]; then
  source "$DOTFILES/zshrc.d/ubuntu.zsh"
fi

# Source shared aliases and functions (after OMZ so these take precedence)
source "$DOTFILES/zshrc.d/aliases.zsh"
source "$DOTFILES/zshrc.d/functions.zsh"

# Tool env vars
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/config"
export PNPM_HOME="$HOME/.local/share/pnpm"
[[ :$PATH: != *":$PNPM_HOME:"* ]] && export PATH="$PNPM_HOME:$PATH"

# Source local overrides if present
if [[ -f "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi

