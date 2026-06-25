# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

Portable dotfiles and bootstrap scripts for Zsh, Neovim, Vim, Git, tmux, fzf, bat, lazygit, Ghostty, and more. Supports Ubuntu and macOS, with local machine overrides via `.zshrc.local`.

## Validation Commands

There is no build pipeline or test suite. Use these lightweight checks after edits:

```sh
# Syntax-check shell scripts
bash -n install.sh install_packages.sh install_firefox.sh install_devcontainer.sh

# Syntax-check Zsh configs
zsh -n .zshrc zshrc.d/ubuntu.zsh zshrc.d/macos.zsh zshrc.d/aliases.zsh zshrc.d/functions.zsh
```

## Architecture

**Symlink model** — `install.sh` symlinks all root dotfiles and `.config/` subdirs into `$HOME`. Source files stay in the repo; `$HOME` entries are symlinks pointing back here. The `lnk()` helper backs up any pre-existing real file before replacing it with a symlink.

**Platform split** — `.zshrc` detects `$OSTYPE` and sources either `zshrc.d/ubuntu.zsh` or `zshrc.d/macos.zsh`. Shared aliases and functions live in `zshrc.d/aliases.zsh` and `zshrc.d/functions.zsh`, sourced after Oh My Zsh so they override OMZ defaults.

**DOTFILES env var** — `.zshrc` resolves its own symlink at startup and exports `$DOTFILES` pointing to the repo root. Platform configs and the `zshrc.d/` directory use this variable.

**Two install paths:**
- `install.sh` — full interactive install (GNOME shortcut, Firefox prompt, sets default shell)
- `install_devcontainer.sh` — headless/container install; skips GUI, GNOME, Firefox, and `chsh`

**App configs under `.config/`** — each tool has a subdirectory (e.g. `.config/ghostty/`, `.config/lazygit/`). `install.sh` creates the target `mkdir -p` and symlinks the file. To add a new tool, add a `lnk` call in both `install.sh` and `install_devcontainer.sh` if it's container-relevant.

**Agent config** — `.config/agent/mcp.json` is the canonical MCP server list, symlinked to `~/.claude.json` and `~/.kiro/settings/mcp.json`. Skills live project-locally in `.claude/skills/`.

**VS Code** — `.config/vscode/settings.json` → `~/.config/Code/User/settings.json`; `.config/vscode/mcp.json` provides MCP server config for VS Code Copilot.

**Firefox** — `install_firefox.sh` detects Snap/Flatpak/native profile locations in priority order and copies `.mozilla/firefox/profile/user.js` (with backup). Run separately from `install.sh` via prompt.

## Conventions

- Scripts use `set -e` (fail-fast) and Bash (not POSIX sh).
- Symlinks use `ln -sfn` (safe re-run, no duplicate nesting).
- `install_firefox.sh` is destructive — it overwrites `user.js` in the live Firefox profile. The backup is automatic but always warn before touching it.
- Private/machine-specific config goes in `.zshrc.local` (git-ignored, sourced last).
- When adding packages, update `software.md` and the `PACKAGES` array in `install_packages.sh`.
- Prefer small targeted edits; avoid broad refactors of bootstrap scripts.
