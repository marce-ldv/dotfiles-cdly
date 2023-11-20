brew install fzf docker neovim nvm
brew install --cask raycast bartender firefox google-chrome iterm2 spotify colorsnapper github obs discord istat-menus

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install zsh-autosuggestions
curl -fsSL https://raw.github.com/zsh-users/zsh-autosuggestions/master/zsh-autosuggestions.zsh -o "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

# install zsh-syntax-highlighting
curl -fsSL https://raw.github.com/zsh-users/zsh-syntax-highlighting/master/zsh-syntax-highlighting.zsh -o "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# install starship
curl -fsSL https://starship.rs/install.sh -o "${HOME}/.dotfiles-cdly/starship/install.sh"
# sh "${HOME}/.dotfiles-cdly/starship/install.sh" --yes --bin-dir "${HOME}/.dotfiles-cdly/starship/bin"

# execute symlinks
"${HOME}/.dotfiles-cdly/symlinks.sh"
