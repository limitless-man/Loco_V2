get_category_folders() {
  local categories_folder="categories"
  local folders=()
  local base_dir=""

  if [[ $EUID -eq 0 ]] && [[ "${SUDO_USER}" != "" ]]; then
    base_dir="/home/${SUDO_USER}/Loco_V2/"
  elif [[ $EUID -eq 0 ]]; then
    base_dir="/root/Loco_V2/"
  fi

  for category_folder in "${base_dir}${categories_folder}"/*; do
    if [[ -d "$category_folder" ]]; then
      folders+=("$(basename "$category_folder")")
    fi
  done

  echo "${folders[@]}"
}
