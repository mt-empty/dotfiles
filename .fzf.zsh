# fzf shell integration
if command -v fzf &>/dev/null; then
  if fzf --version 2>/dev/null | awk '{split($1,v,"."); exit !(v[1]>0 || v[2]>=48)}'; then
    source <(fzf --zsh)
  elif [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
    [[ -f /usr/share/doc/fzf/examples/completion.zsh ]] && source /usr/share/doc/fzf/examples/completion.zsh
  elif [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
    source /usr/share/fzf/key-bindings.zsh
    [[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
  fi
fi

# Use fd for fzf if available, otherwise fall back to find
if command -v fd &>/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
else
  export FZF_DEFAULT_COMMAND='find . -type f -not -path "*/\.git/*"'
fi

export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
