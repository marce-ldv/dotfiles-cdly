#!/usr/bin/env bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

OLD_UBUNTU=false
if lsb_release -a | grep -q "18.04"; then
  echo "*** Old ubuntu detected ***"
  OLD_UBUNTU=true
fi

echo "Enter the terminal language (es_AR.UTF-8, en_US.UTF-8, etc ): "
read language

sudo locale-gen ${language}
sudo update-locale LANG=${language}

mkdir -p "${HOME}/.dotfiles-cdly/mods/"

echo "export LC_ALL=\"${language}\"
export LANG=\"${language}\"
export LANGUAGE=\"${language}\"
export LC_NUMERIC=\"${language}\"
export LC_TIME=\"${language}\"
export LC_MONETARY=\"${language}\"
export LC_PAPER=\"${language}\"
export LC_IDENTIFICATION=\"${language}\"
export LC_NAME=\"${language}\"
export LC_ADDRESS=\"${language}\"
export LC_TELEPHONE=\"${language}\"
export LC_MEASUREMENT=\"${language}\"" >"${HOME}/.dotfiles-cdly/mods/language.sh" || exit 100

echo "**** Installing... ****"
sudo apt update && sudo apt install -y curl git zsh dnsutils rsync build-essential fontconfig || exit 100

# sudo gem uninstall -aIx;
# sudo gem uninstall -i /usr/share/rubygems-integration/all minitest;
# sudo apt purge ruby ruby-dev libffi-dev libssl-dev libreadline-dev;


# install icons for ls
architecture=$(dpkg --print-architecture)
case $architecture in
    armhf) echo "ARM detecterd, ignoring some configs" ;;
    *)     sudo bash "${HOME}/.dotfiles-cdly/github/dpkg-github.sh" -a "$(dpkg --print-architecture)" -i Peltoche/lsd ;;
esac

# fix for old ubuntu fzf
if [ "${OLD_UBUNTU}" = true ]; then
  echo "* Applying old ubuntu patches"
  # sudo gem update --system 3.0.6 && sudo gem install colorls && sudo gem pristine rake || exit 100
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
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" || exit 100
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" || exit 100

echo "**** installing starship... ****"

sh -c "$(curl -fsSL https://starship.rs/install.sh)" || exit 100

echo "**** Updating scripts and dotfiles... ****"

# find out which distribution we are running on
_distro=$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }')

# https://realjenius.com/2020/01/12/kde-neon-snap-apps-missing/
case $_distro in
*neon*)
  echo "Configuring KDE NEO fixes.."
  echo "# /etc/zsh/zprofile: system-wide .zprofile file for zsh(1).
#
# This file is sourced only for login shells (i.e. shells
# invoked with '-' as the first character of argv[0], and
# shells invoked with the -l flag.)
#
# Global Order: zshenv, zprofile, zshrc, zlogin

emulate sh -c 'source /etc/profile.d/apps-bin-path.sh'
" | sudo tee /etc/zsh/zprofile
  ;;
esac

[[ -f "${HOME}/.dotfiles-cdly/mods/install.sh" ]] && source "${HOME}/.dotfiles-cdly/mods/install.sh"

bash "${HOME}/.dotfiles-cdly/update.sh" || exit 100

echo "************************  DONE  **********************************"
echo "**** Configure terminal to use this fonts: 'JetBrainsMono Nerd Font Mono Regular' ****"
echo "**** Configure editors to use this font: 'JetBrainsMono Nerd Font' ****"
echo "**** RESTART TERMINAL! ****"
