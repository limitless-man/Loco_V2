# Checks if specified packages are installed and installs them if not
# Input: List of package names
# Output: None
function check_dependencies() {
    #clear

    # Check if running as root
    if [ "$(id -u)" -ne 0 ]; then
        echo "This script requires root permissions to run"
        exit 1
    fi

    # Get list of packages to check
    declare -a packages=("$@")

    # Loop through packages and check if installed
    for pkg in "${packages[@]}"
    do
        # If package is not installed, install it
        if ! dpkg -s "$pkg" &> /dev/null
        then
            echo "Package '$pkg' is not installed. Installing it now..."
            apt-get install -y "$pkg"
        else
            echo "Package '$pkg' is already installed"
        fi
    done
}
