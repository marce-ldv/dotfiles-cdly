#!/usr/bin/env bash

echo "**** Updating ... ****"
echo "* configs.."
rsync -ahzc "${HOME}/.dotfiles/.p10k.zsh" "${HOME}/" || exit 100
rsync -ahzc "${HOME}/.dotfiles/.zshrc" "${HOME}/" || exit 100
rsync -ahzc "${HOME}/.dotfiles/.nanorc" "${HOME}/" || exit 100
sudo rsync -ahzc "${HOME}/.dotfiles/.nanorc" "/root/" || exit 100
mkdir -p "${HOME}/.config/neofetch/" || exit 100
rsync -ahzc "${HOME}/.dotfiles/neofetch.conf" "${HOME}/.config/neofetch/config.conf" || exit 100
echo "* powerlevel10k.."
git -C ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k pull || exit 100
echo "* autosuggestions.."
git -C ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions pull || exit 100
echo "* highlighting.."
git -C ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting pull || exit 100
echo "* colorsls.."
sudo gem update colorls || exit 100
echo "* zsh.."

echo "
**************************
if you manually run update.sh, RUN THIS COMMANDS!
omz update && src
"