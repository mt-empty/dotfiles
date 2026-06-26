# Common aliases (all platforms)
alias gs='git status'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gpf='git push --force-with-lease'
gcaf() {
  git diff --cached --quiet && { echo "gcaf: nothing staged to amend"; return 1; }
  git commit --amend --no-edit && git push --force-with-lease
}
