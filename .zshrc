# Main Zsh configuration
# Resolve the dotfiles repo location from this file's symlink
_zrc="${(%):-%x}"
[[ -L "$_zrc" ]] && _zrc="$(readlink "$_zrc")"
export DOTFILES="${_zrc:h}"
unset _zrc

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

# Source local overrides if present
if [[ -f "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi

