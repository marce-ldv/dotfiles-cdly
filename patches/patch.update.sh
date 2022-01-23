#!/usr/bin/env bash

echo "**** Updating marce settings... ****"
bash "${HOME}/.dotfiles/patch.zshrc.sh" || exit 100
