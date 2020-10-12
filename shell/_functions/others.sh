function export_apps() {
  apt list --installed > ${HOME}/.dotfiles/so/linux/apt-installed.txt
  echo "Apt apps exported !!"
  
  ls -1 /usr/local/lib/node_modules | grep -v npm >"$DOTFILES_PATH/langs/js/global_modules.txt"
  echo "Npm apps exported !!"
}