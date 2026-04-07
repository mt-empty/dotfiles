# Project Guidelines

## Scope
- This repository manages shell/editor/tool dotfiles and bootstrap scripts for Linux and macOS.
- Keep instructions minimal and actionable. Link to existing docs instead of duplicating them.

## Architecture
- Root dotfiles are source files that get symlinked into `$HOME` by `install.sh`.
- Platform shell config lives in `zshrc.d/` and is sourced from `.zshrc` by `OSTYPE`.
- App/tool config is primarily under `.config/`.
- Firefox preferences template is in `.mozilla/firefox/profile/user.js` and is applied by `install_firefox.sh`.

## Build And Test
- There is no build pipeline and no automated test suite in this repo.
- Primary setup command: `./install.sh`
- Optional package installer: `./install_packages.sh` (interactive)
- Optional Firefox profile setup: `./install_firefox.sh`

When validating changes, prefer lightweight manual checks:
- `bash -n install.sh install_packages.sh install_firefox.sh`
- `zsh -n .zshrc zshrc.d/ubuntu.zsh zshrc.d/macos.zsh`

## Conventions
- Preserve idempotent symlink behavior in `install.sh` (`ln -sf` and `ln -snf`).
- Keep scripts POSIX/Bash-friendly and fail-fast (`set -e`).
- Do not silently convert interactive flows to non-interactive behavior unless requested.
- Treat `install_firefox.sh` as potentially destructive: it overwrites profile `user.js` after backup.
- Keep private/local machine overrides in `.zshrc.local` and avoid committing secrets.

## Agent Behavior
- Before changing install behavior, review the current user-facing flow in `readme.md`.
- If a change affects package lists or recommendations, update `software.md` when relevant.
- Prefer small, targeted edits over broad refactors in bootstrap scripts.
- If proposing additional contributor guidance, link existing docs first:
	- `readme.md`
	- `software.md`
