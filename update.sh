#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "**** Updating ... ****"
echo "* configs.."
sudo locale-gen es_AR.UTF-8
sudo update-locale LANG=es_AR.UTF-8
rsync -ahzc "${HOME}/.dotfiles/zsh/.p10k.zsh" "${HOME}/" || exit 100
rsync -ahzc "${HOME}/.dotfiles/zsh/.zshrc" "${HOME}/" || exit 100
rsync -ahzc "${HOME}/.dotfiles/dotfiles/.nanorc" "${HOME}/" || exit 100
sudo rsync -ahzc "${HOME}/.dotfiles/dotfiles/.nanorc" "/root/" || exit 100
mkdir -p "${HOME}/.config/neofetch/" || exit 100
rsync -ahzc "${HOME}/.dotfiles/dotfiles/neofetch.conf" "${HOME}/.config/neofetch/config.conf" || exit 100
echo "* powerlevel10k.."
git -C ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/themes/powerlevel10k pull || exit 100
echo "* autosuggestions.."
git -C ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions pull || exit 100
echo "* highlighting.."
git -C ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting pull || exit 100
echo "* colorsls.."
sudo gem update colorls || exit 100
echo "* zsh.."

sh -c "$(curl -fsSL https://starship.rs/install.sh)" || exit 100
cp "${SCRIPT_DIR}/starship/starship.toml" "${HOME}/.config/starship.toml" || exit 100

echo "
**************************
if you manually run update.sh, RUN THIS COMMANDS!

omz update && omz reload
"
