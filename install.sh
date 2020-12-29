#!/usr/bin/env bash
echo "**** Installing... ****"
sudo apt update && sudo apt install -y curl zsh rsync ruby ruby-dev build-essential && sudo gem install rubygems-update && sudo gem update --system && sudo gem install colorls || exit 100

# fix for old ubuntu fzf
if [ "${OLD_UBUNTU}" = true ]; then
  echo "* Applying old ubuntu patches"
  sudo gem update --system 3.0.6 && sudo gem install colorls && sudo gem pristine rake || exit 100
  if [ ! -d "${HOME}/.fzf" ]; then
    echo "* fzf not found, trying to install..."
    git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}/.fzf" || exit 100
  fi
  "${HOME}"/.fzf/install || exit 100
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

bash "${HOME}/.dotfiles/update.sh" || exit 100

echo "**** Configuring... ****"

chsh -s "$(which zsh)"  || exit 100

if grep -iq Microsoft /proc/version; then
  echo ""
  echo "************************  DONE  **********************************"
  echo "* Ubuntu on Windows detected *"
  echo "*** Install this fonts MANUALLY ***"
  echo "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/JetBrainsMono/Regular/complete/JetBrains%20Mono%20Regular%20Nerd%20Font%20Complete%20Mono%20Windows%20Compatible.ttf"
  echo "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/JetBrainsMono/Regular/complete/JetBrains%20Mono%20Regular%20Nerd%20Font%20Complete%20Windows%20Compatible.ttf"
  echo "**** Configure terminal to use this fonts: 'JetBrainsMono NF' ****"
  echo "**** Configure editors to use this font: 'JetBrainsMono NF' ****"
else
  rm -rf "${HOME}/.dotfiles/.myCache" &&  mkdir -p "${HOME}/.dotfiles/.myCache" && cd "${HOME}/.dotfiles/.myCache" || exit 100
  wget --no-check-certificate --content-disposition "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/JetBrainsMono/Regular/complete/JetBrains%20Mono%20Regular%20Nerd%20Font%20Complete%20Mono.ttf" || exit 100
  wget --no-check-certificate --content-disposition "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/JetBrainsMono/Regular/complete/JetBrains%20Mono%20Regular%20Nerd%20Font%20Complete.ttf" || exit 100
  mkdir -p "${HOME}/.local/share/fonts" || exit 100
  rsync -ahzc "${HOME}/.dotfiles/.myCache/" "${HOME}/.local/share/fonts"
  fc-cache -f -v || exit 100
  echo ""
  echo "************************  DONE  **********************************"
  echo "**** Configure terminal to use this fonts: 'JetBrainsMono Nerd Font Mono Regular' ****"
  echo "**** Configure editors to use this font: 'JetBrainsMono Nerd Font' ****"
fi

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
PATH="$HOME/bin:$HOME/.local/bin:/usr/bin:$PATH"

mkdir ~/${HOME}/code/

echo "* Installing NPM"
sudo apt-get install -y nodejs build-essential npm || exit 100
echo "* NPM was successfully installed"
echo "* Installing XDG Utils"
sudo apt install xdg-utils || exit 100
echo "* XDG-Utils was successfully installed"
echo "* Installing NVM"
sudo curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash || exit 100
echo "* NVM was successfully installed"
# echo "* Installing YARN"
# sudo npm i -g yarn || exit 100
# echo "* YARN was successfully installed"

# echo "* Installing JETBRAINS TOOLBOX"
# set -e

# if [ -d ~/.local/share/JetBrains/Toolbox ]; then
#     echo "JetBrains Toolbox is already installed!"
#     exit 0
# fi

# echo "Start installation..."

# wget --show-progress -qO ./toolbox.tar.gz https://download-cf.jetbrains.com/toolbox/jetbrains-toolbox-1.14.5179.tar.gz

# TOOLBOX_TEMP_DIR=$(mktemp -d)

# tar -C "$TOOLBOX_TEMP_DIR" -xf toolbox.tar.gz
# rm ./toolbox.tar.gz

# "$TOOLBOX_TEMP_DIR"/*/jetbrains-toolbox

# rm -r "$TOOLBOX_TEMP_DIR"

# echo "JetBrains Toolbox was successfully installed!"

# echo "* Installing DOCKER"
# sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
# sudo apt update -y
# sudo apt install docker-ce -y

# echo "* Docker was successfully installed"

# echo "* Executing the Docker Command Without Sudo"
# sudo usermod -aG docker ${USER}
# su - ${USER}
# sudo usermod -aG docker username

# echo "* DONE"
# echo "* You can try type docker run hello-world to test"

# echo "* Installing Google Chrome"
# wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# sudo apt install ./google-chrome-stable_current_amd64.deb
# echo "* Google Chrome was successfully installed"

# echo "* Installing Slack"
# wget https://downloads.slack-edge.com/linux_releases/slack-desktop-4.0.2-amd64.deb
# sudo apt install ./slack-desktop-*.deb
# echo "* Slack was successfully installed"

echo "* Install Cargo"
sudo apt install cargo -y
echo "* Cargo Installed"

echo "* Install TLDR"
sudo apt install tldr -y
echo "* TLDR Installed"

echo "**** RESTART TERMINAL! ****"