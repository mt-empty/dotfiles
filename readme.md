# programs
- brew
- Inav
- nvim
-
# Dotfiles for Ubuntu & macOS

This repository contains portable dotfiles and setup scripts for Zsh, Vim, Git, tmux, fzf, bat, lazygit, and more. It supports local overrides and platform-specific configuration.

## Features
- Zsh as the primary shell
- Oh My Zsh automatic installation
- Platform-specific configs (Ubuntu/macOS)
- Private local overrides via `.zshrc.local` (git-ignored)
- Interactive, selective package installation
- VS Code settings/extensions support

## Setup
1. Clone this repo to `~/.dotfiles` or your preferred location.
2. Run the install script:
	```sh
	cd ~/.dotfiles
	./install.sh
	```
3. (Optional) Install packages interactively:
	```sh
	./install_packages.sh
	```
4. (Optional) Add private, machine-specific settings to `.zshrc.local` (this file is ignored by git).

## Platform-Specific Configs
- `zshrc.d/ubuntu.zsh` — Ubuntu-specific Zsh config
- `zshrc.d/macos.zsh` — macOS-specific Zsh config

## Software List
See [software.md](software.md) for core and recommended tools, including Inav.

## VS Code
- Place your VS Code settings in `.vscode/settings.json` and extensions in `.vscode/extensions.json`.

## Local Overrides
- Add any private or machine-specific Zsh config to `.zshrc.local` (not tracked by git).

## License
MIT
