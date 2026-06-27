# Common aliases (all platforms)
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gpf='git push --force-with-lease'
alias gpm='git pull origin main'

gcaf() {
  git diff --cached --quiet && { echo "gcaf: nothing staged to amend"; return 1; }
  git commit --amend --no-edit && git push --force-with-lease
}
