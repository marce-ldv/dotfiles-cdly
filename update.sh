#!/usr/bin/env bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

echo "**** Updating ... ****"

echo "* configs.."
rsync -ahzc "${HOME}/.dotfiles-cdly/zsh/.p10k.zsh" "${HOME}/" || exit 100
rsync -ahzc "${HOME}/.dotfiles-cdly/zsh/.zshrc" "${HOME}/" || exit 100
rsync -ahzc "${HOME}/.dotfiles-cdly/dotfiles/.nanorc" "${HOME}/" || exit 100
sudo rsync -ahzc "${HOME}/.dotfiles-cdly/zsh/.p10k.zsh" "/root/" || exit 100
sudo rsync -ahzc "${HOME}/.dotfiles-cdly/zsh/.zshrc" "/root/" || exit 100
sudo rsync -ahzc "${HOME}/.dotfiles-cdly/dotfiles/.nanorc" "/root/" || exit 100
mkdir -p "${HOME}/.config/neofetch/" || exit 100
sudo mkdir -p "/root/.config/neofetch/" || exit 100
rsync -ahzc "${HOME}/.dotfiles-cdly/dotfiles/neofetch.conf" "${HOME}/.config/neofetch/config.conf" || exit 100
sudo rsync -ahzc "${HOME}/.dotfiles-cdly/dotfiles/neofetch.conf" "/root/.config/neofetch/config.conf" || exit 100

echo "* autosuggestions.."
git -C ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions pull || exit 100
[[ -d "/root/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]] && sudo git -C ${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}/plugins/zsh-autosuggestions pull

echo "* highlighting.."
git -C ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting pull || exit 100
[[ -d "/root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]] && sudo git -C ${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting pull

# update icons for ls
architecture=$(dpkg --print-architecture)
case $architecture in
    armhf) echo "ARM detecterd, ignoring some configs" ;;
    *)     sudo bash "${HOME}/.dotfiles-cdly/github/dpkg-github.sh" -a "$(dpkg --print-architecture)" -i Peltoche/lsd
esac

echo "* starship.."
sh -c "$(curl -fsSL https://starship.rs/install.sh)" || exit 100
cp "${SCRIPT_DIR}/starship/starship.toml" "${HOME}/.config/starship.toml" || exit 100
sudo cp "${SCRIPT_DIR}/starship/starship.toml" "/root/.config/starship.toml" || exit 100

echo "* fonts.."
mkdir -p ~/.local/share/fonts && cd ~/.local/share/fonts || exit 100
curl -fLo "JetBrains Mono Regular Nerd Font Complete Mono.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Regular/complete/JetBrains%20Mono%20Regular%20Nerd%20Font%20Complete%20Mono.ttf || exit 100
curl -fLo "JetBrains Mono Regular Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Regular/complete/JetBrains%20Mono%20Regular%20Nerd%20Font%20Complete.ttf || exit 100
fc-cache -f -v || exit 100

[[ -f "${HOME}/.dotfiles-cdly/mods/update.sh" ]] && source "${HOME}/.dotfiles-cdly/mods/update.sh"

echo "
**************************
if you manually run update.sh, RUN THIS COMMANDS!
omz update && omz reload
**************************
"
