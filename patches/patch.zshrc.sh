#!/usr/bin/env bash

echo '
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
alias open='\''xdg-open'\''
alias ushellm='\''bash ~/.dotfiles/update.sh && omz update && bash ~/.dotfiles/patch.update.sh && omz reload'\''
alias pshellm='\''cd ~/.dotfiles && git pull && bash ~/.dotfiles/update.sh  && bash ~/.dotfiles/patch.update.sh && omz update && omz reload'\''
alias cdc='\''cd ~/code'\''
' >>"${HOME}/.zshrc"
