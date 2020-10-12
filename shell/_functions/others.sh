function export_apps() {
  apt list --installed > ${HOME}/.dotfiles/so/linux/apt-installed.txt
  echo "Apt apps exported !!"
  
  ls -1 /usr/local/lib/node_modules | grep -v npm >"$DOTFILES_PATH/langs/js/global_modules.txt"
  echo "Npm apps exported !!"
}

function import_apps() {
  sudo dpkg-query -l | awk '{if ($1 == "ii") print $2}' > packages_list.txt
  sudo xargs -a packages_list.txt apt install
  echo "Imported apps exported !!"

  xargs -I_ npm install -g "_" < "$DOTFILES_PATH/langs/js/global_modules.txt"
  cat "$DOTFILES_PATH/langs/js/global_modules.txt" | xargs -I_ npm install -g
  echo "Npm apps exported !!"
}
