# function system_cleanup() {
#     sudo apt-get update && \
#     sudo apt-get -y upgrade && \
#     sudo apt-get -y autoremove && \
#     sudo apt-get -y autoclean
# }


function system_cleanup() {
    if ! runWithLoading "Updating Distro" "sudo apt-get update"; then
    exit 1
    fi

    if ! runWithLoading "upgrading Distro" "sudo apt-get -y upgrade"; then
    exit 1
    fi

    if ! runWithLoading "Auto remove packages" "sudo apt-get -y autoremove"; then
    exit 1
    fi

    if ! runWithLoading "Cleaning leftovers" "sudo apt-get -y autoclean -y"; then
    exit 1
    fi

    if ! runWithLoading "Dist Upgrade" "sudo apt dist-upgrade -y"; then
    exit 1
    fi
}