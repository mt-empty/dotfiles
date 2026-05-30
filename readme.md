# Dotfiles for Ubuntu & macOS

Portable dotfiles and setup scripts for Zsh, Neovim, Vim, Git, tmux, fzf, bat, lazygit, Ghostty, and more. Supports local overrides and platform-specific configuration.

## Features
- Zsh + Oh My Zsh (auto-installed)
- Platform-specific configs (Ubuntu/macOS)
- Neovim config (`~/.config/nvim/init.vim`) and Vim config (`~/.vimrc`)
- Ghostty quake-mode toggle script with GNOME shortcut registration (Ctrl+Escape)
- VS Code global user settings and MCP config
- Claude and Kiro MCP configs
- Private local overrides via `.zshrc.local` (git-ignored)
- Interactive, selective package installation

## Setup
1. Clone this repo anywhere:
	```sh
	git clone https://github.com/youruser/dotfiles ~/dotfiles
	cd ~/dotfiles
	```
2. Run the install script:
	```sh
	./install.sh
	```
3. (Optional) Install packages interactively:
	```sh
	./install_packages.sh
	```
4. (Optional) Add private, machine-specific settings to `.zshrc.local` (git-ignored).

## Dev Container
For headless environments, use `install_devcontainer.sh` instead — it skips GUI, GNOME, and Firefox steps.

## Platform-Specific Configs
- `zshrc.d/ubuntu.zsh` — Ubuntu-specific Zsh config
- `zshrc.d/macos.zsh` — macOS-specific Zsh config

## VS Code
`install.sh` symlinks `.config/vscode/settings.json` to `~/.config/Code/User/settings.json` (global user settings) and installs MCP config and Copilot instructions.

## Local Overrides
Add any private or machine-specific Zsh config to `.zshrc.local` (not tracked by git).

## Software List
See [software.md](software.md) for core and recommended tools.

## License
MIT
