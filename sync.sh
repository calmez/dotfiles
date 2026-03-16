#!/usr/bin/env bash
stow config --target ~/.config
stow zsh --dotfiles

if [[ ! -e ~/.config/tmux/plugins ]]; then
  git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
fi
