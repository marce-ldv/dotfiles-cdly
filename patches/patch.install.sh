#!/usr/bin/env bash
bash ~/.dotfiles/install.sh

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
sudo curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash || exit 100
echo "* NVM was successfully installed"
echo "* Installing YARN"
sudo npm i -g yarn || exit 100
echo "* YARN was successfully installed"

echo "* Installing JETBRAINS TOOLBOX"
set -e

if [ -d ~/.local/share/JetBrains/Toolbox ]; then
    echo "JetBrains Toolbox is already installed!"
    exit 0
fi

echo "Start installation..."

wget --show-progress -qO ./toolbox.tar.gz https://download-cf.jetbrains.com/toolbox/jetbrains-toolbox-1.14.5179.tar.gz

TOOLBOX_TEMP_DIR=$(mktemp -d)

tar -C "$TOOLBOX_TEMP_DIR" -xf toolbox.tar.gz
rm ./toolbox.tar.gz

"$TOOLBOX_TEMP_DIR"/*/jetbrains-toolbox

rm -r "$TOOLBOX_TEMP_DIR"

echo "JetBrains Toolbox was successfully installed!"

echo "* Installing DOCKER"
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update -y
sudo apt install docker-ce -y

echo "* Docker was successfully installed"

echo "* Executing the Docker Command Without Sudo"
sudo usermod -aG docker ${USER}
su - ${USER}
sudo usermod -aG docker username

echo "* DONE"
echo "* You can try type docker run hello-world to test"

echo "* Installing Google Chrome"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
echo "* Google Chrome was successfully installed"

echo "* Installing Slack"
wget https://downloads.slack-edge.com/linux_releases/slack-desktop-4.0.2-amd64.deb
sudo apt install ./slack-desktop-*.deb
echo "* Slack was successfully installed"

echo "* Executing path update"
bash "${HOME}/.dotfiles/patch.update.sh" || exit 100
echo "ending path update"
