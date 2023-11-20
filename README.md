# Dotfiles Ldv

## Installation

### Mac

Wip

### PowerShell

If you're using SSH and will contribute to the project, install using the following command:

```shell
cd ~ && mkdir ~/.dotfiles-cdly && git clone git@github.com:marce-ldv/dotfiles-cdly.git .dotfiles-cdly && pwsh .dotfiles-cdly/install.ps1
```

If you're only using these scripts, use the following command:

```shell
cd ~ && mkdir ~/.dotfiles-cdly && git clone https://github.com/marce-ldv/dotfiles-cdly .dotfiles-cdly && pwsh .dotfiles-cdly/install.ps1
```

### BASH

If you're using SSH and will contribute to the project, install using the following command:

```shell
mkdir ~/.dotfiles-cdly && git clone git@github.com:marce-ldv/dotfiles-cdly.git ~/.dotfiles-cdly && bash ~/.dotfiles-cdly/install.sh
```

If you're only using these scripts, use the following command:

```shell
mkdir ~/.dotfiles-cdly && git clone https://github.com/marce-ldv/dotfiles-cdly ~/.dotfiles-cdly && bash ~/.dotfiles-cdly/install.sh
```

## Updating scripts and plugins

To update zsh with the latest local modifications, use the command:

```shell
ushell
```

To update all repositories and local configs, use the command:

```shell
pshell
```

## Aliases

```shell
alias uos='sudo apt update && sudo apt -y upgrade && sudo apt -y autoremove'
alias ushell='bash ~/.dotfiles-cdly/update.sh && omz update && omz reload'
alias pshell='cd ~/.dotfiles-cdly && git pull && bash ~/.dotfiles-cdly/update.sh && omz update && omz reload'
```
