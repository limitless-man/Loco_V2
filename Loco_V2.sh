#!/bin/bash
clear

# Get the path of the directory containing this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Import the source function
source "${SCRIPT_DIR}/functions/source_functions.sh"

# Add additional function directories
source_additional_scripts \
    "nav" \
    "menu_functions"

# Import functionality
core_scripts=(
    "check_root.sh"        # Core: Checks if the user is running the script as root
    "show_menu.sh"         # Core: Displays the main menu
    "display_help.sh"      # Core: Displays help and available commands
    "get_category_folders.sh"  # Core: Retrieves category folders
    "handle_category_selection.sh"  # Core: Handles category selection
    "use_arguments.sh"     # Core: Handles command-line arguments
)

### =============================== ###
### Additional Functionality Scripts ###
### =============================== ###

# Import additional functionality scripts
additional_scripts=(
    "unattended_updates.sh"     # Performs unattended updates
    "logrotate_file.sh"         # Performs log rotation
    "harden_ssh.sh"             # Hardens SSH security settings
    "install_package.sh"        # Installs packages
    "check_dependencies.sh"     # Checks and installs dependencies
)

# Source each script from the core_scripts array
for script in "${core_scripts[@]}"; do
    source_functions "$script"
done

# Source each script from the additional_scripts array
for script in "${additional_scripts[@]}"; do
    source_functions "$script"
done

    ### =============================== ###
    ### Scripts from Categories Folder ###
    ### =============================== ###

category_scripts=(
    "Docker"
    "Packages"
    "Security"
    "Updates"
)

# Source each script from the category_scripts array
for category in "${category_scripts[@]}"; do
    source_category_scripts "$category"
done

    ### =============================== ###
    ### Rest of the Script ###
    ### =============================== ###

# Check if -h or --help is provided
if [[ $1 == "-h" ]] || [[ $1 == "--help" ]]; then
    display_help
    exit 0
fi

# Call for arguments to use the script
if [ $# -gt 0 ]; then
  if [ "$1" == "check_root" ]; then
    call_function "$@"
  else
    # Call a different function based on your choosing
    # Call the function to source category scripts
    categories=($(get_category_folders))  # Assign categories to an array

    # Call the function to display the main menu
    show_menu "${categories[@]}"  # Pass categories as separate arguments
  fi
else
  # Call a different function based on your choosing
  # Call the function to source category scripts
  categories=($(get_category_folders))  # Assign categories to an array

  # Call the function to display the main menu
  show_menu "${categories[@]}"  # Pass categories as separate arguments
fi
