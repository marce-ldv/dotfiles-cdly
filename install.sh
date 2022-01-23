#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

OLD_UBUNTU=false
if lsb_release -a | grep -q "18.04"; then
  echo "*** Old ubuntu detected ***"
  OLD_UBUNTU=true
fi

echo "**** Installing... ****"
sudo apt update && sudo apt install -y curl git zsh dnsutils rsync ruby ruby-dev build-essential && sudo gem install rubygems-update && sudo gem update --system && sudo gem install colorls || exit 100

# fix for old ubuntu fzf
if [ "${OLD_UBUNTU}" = true ]; then
  echo "* Applying old ubuntu patches"
  sudo gem update --system 3.0.6 && sudo gem install colorls && sudo gem pristine rake || exit 100
  if [ ! -d "${HOME}/.fzf" ]; then
    echo "* fzf not found, trying to install..."
    git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}/.fzf" || exit 100
  fi
  "${HOME}/.fzf/install" || exit 100
else
  sudo apt install -y fzf bat || exit 100
fi

# removing old files
sudo rm -rf "${HOME}/.oh-my-zsh" || exit 100
read -p "***=== Press enter, then type 'exit' and enter, after next prompt!. ===*** " CONT
cd "${HOME}" && sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" || exit 100
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/themes/powerlevel10k" || exit 100
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" || exit 100
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" || exit 100

echo "**** installing starship... ****"

sh -c "$(curl -fsSL https://starship.rs/install.sh)" || exit 100

echo "**** Updating scripts and dotfiles... ****"

bash "${HOME}/.dotfiles/update.sh" || exit 100

echo "**** Configuring... ****"

# https://realjenius.com/2020/01/12/kde-neon-snap-apps-missing/
echo "# /etc/zsh/zprofile: system-wide .zprofile file for zsh(1).
#
# This file is sourced only for login shells (i.e. shells
# invoked with "-" as the first character of argv[0], and
# shells invoked with the -l flag.)
#
# Global Order: zshenv, zprofile, zshrc, zlogin

emulate sh -c 'source /etc/profile.d/apps-bin-path.sh'
" | sudo tee /etc/zsh/zprofile

chsh -s "$(which zsh)"  || exit 100

if grep -iq Microsoft /proc/version; then
  echo ""
  echo "************************  DONE  **********************************"
  echo "* Ubuntu on Windows detected *"
  echo "*** Install this fonts MANUALLY ***"
  echo "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete%20Mono%20Windows%20Compatible.ttf"
  echo "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete%20Windows%20Compatible.ttf"
  echo "**** Configure terminal to use this fonts: 'JetBrainsMono NF' ****"
  echo "**** Configure editors to use this font: 'JetBrainsMono NF' ****"
else
  rm -rf "${HOME}/.dotfiles/.myCache" &&  mkdir -p "${HOME}/.dotfiles/.myCache" && cd "${HOME}/.dotfiles/.myCache" || exit 100
  wget --no-check-certificate --content-disposition "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete%20Mono%20Windows%20Compatible.ttf" || exit 100
  wget --no-check-certificate --content-disposition "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete%20Windows%20Compatible.ttf" || exit 100
  mkdir -p "${HOME}/.local/share/fonts" || exit 100
  rsync -ahzc "${HOME}/.dotfiles/.myCache/" "${HOME}/.local/share/fonts"
  fc-cache -f -v || exit 100
  echo ""
  echo "************************  DONE  **********************************"
  echo "**** Configure terminal to use this fonts: 'JetBrainsMono Nerd Font Mono Regular' ****"
  echo "**** Configure editors to use this font: 'JetBrainsMono Nerd Font' ****"
fi

echo "**** RESTART TERMINAL! ****"
