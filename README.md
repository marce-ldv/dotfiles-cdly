# dotfiles-cdly
Preview WSL2:
![Screenshot](md/wsl2.png)
Preview KDE:
![Screenshot](md/kde.jpeg)

# Install

### PowrShell
If using SSH, and will contribute to the project, install using:
```
cd ~ && mkdir ~/.dotfiles && git clone git@github.com:marce-ldv/dotfiles-cdly.git .dotfiles && pwsh .dotfiles/install.ps1
```
If just using this scripts, install using:
```
cd ~ && mkdir ~/.dotfiles && git clone https://github.com/marce-ldv/dotfiles-cdly .dotfiles && pwsh .dotfiles/install.ps1
```
### BASH
If using SSH, and will contribute to the project, install using:
```
mkdir ~/.dotfiles && git clone git@github.com:marce-ldv/dotfiles-cdly.git ~/.dotfiles && bash ~/.dotfiles/install.sh
```
If just using this scripts, install using:
```
mkdir ~/.dotfiles && git clone https://github.com/marce-ldv/dotfiles-cdly ~/.dotfiles && bash ~/.dotfiles/install.sh
```
## Update all scripts and plugins
for update zsh with latest LOCAL modifications, use:
```
ushell
```
To update all repositories and update local configs, you can use:
```
pshell
```
## Aliases
```
alias uos='sudo apt update && sudo apt -y upgrade && sudo apt -y autoremove'
alias ushell='bash ~/.dotfiles/update.sh && omz update && omz reload'
alias pshell='cd ~/.dotfiles && git pull && bash ~/.dotfiles/update.sh && omz update && omz reload'
```