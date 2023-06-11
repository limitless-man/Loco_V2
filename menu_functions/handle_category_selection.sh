handle_category_selection() {
  local category="$1"
  local categories_folder="categories"
  local base_dir=""

  if [[ $EUID -eq 0 ]] && [[ "${SUDO_USER}" != "" ]]; then
    base_dir="/home/${SUDO_USER}/Loco_V2/"
  elif [[ $EUID -eq 0 ]]; then
    base_dir="/root/Loco_V2/"
  fi

  local category_folder="${base_dir}${categories_folder}/${category}"

  if [[ ! -d "$category_folder" ]]; then
    echo -e "\e[31mCategory folder '$category' does not exist.\e[0m"
    return
  fi

  clear
  echo -e "\e[32mCategory: $category\e[0m"
  echo -e "\e[33mScripts:\e[0m"

  local scripts=()
  local index=1

  for script in "$category_folder"/*.sh; do
    if [[ -f "$script" ]]; then
      local script_name="${script##*/}"  # Get script name without the path
      script_name="${script_name%.*}"    # Remove file extension
      script_name="${script_name//_/ }"  # Replace "_" with space

      # Capitalize first letter of each word
      script_name=$(echo "$script_name" | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1')

      scripts+=("$script_name")
      echo -e "\e[34m$index. $script_name\e[0m"
      ((index++))
    fi
  done

  read -rp "Enter the script number to run (or 'b' to go back to the main menu): " choice

  if [[ $choice == "b" ]]; then
    return
  elif [[ $choice -ge 1 && $choice -le ${#scripts[@]} ]]; then
    local selected_script="${scripts[choice-1]}"
    local function_name="${selected_script// /_}"  # Replace spaces with underscores
    function_name="${function_name,,}"  # Convert to lowercase
    function_name="${function_name%.*}"  # Remove .sh extension

    echo -e "\e[32mRunning the function: $function_name\e[0m"
    "$function_name"  # Run the function directly

    read -rp "Press enter to continue..."
  else
    echo -e "\e[31mInvalid choice. Please try again.\e[0m"
    read -rp "Press enter to continue..."
  fi
}
