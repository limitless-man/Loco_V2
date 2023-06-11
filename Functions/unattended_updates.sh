# Backup existing files: Create backup files for the current configuration files for unattended upgrades and automatic updates.
# Comment out contents of 90apt-clean: Comment out the contents of the 90apt-clean file to disable automatic clean-up of installed packages.
# Get default files from official repository: Copy the default configuration files for unattended upgrades and automatic updates from the official repository to replace the current configuration files.

function restore_unattended_default() {
    # Backup existing files
    sudo cp /etc/apt/apt.conf.d/50unattended-upgrades /etc/apt/apt.conf.d/50unattended-upgrades.bak
    sudo cp /etc/apt/apt.conf.d/20auto-upgrades /etc/apt/apt.conf.d/20auto-upgrades.bak
    sudo cp /etc/apt/apt.conf.d/90apt-clean /etc/apt/apt.conf.d/90apt-clean.bak
    
    # Comment out contents of 90apt-clean
    sudo sed -i 's/^/#/' /etc/apt/apt.conf.d/90apt-clean
    
    # Get default files from official repository
    sudo cp /usr/share/unattended-upgrades/50unattended-upgrades /etc/apt/apt.conf.d/50unattended-upgrades
    sudo cp /usr/share/unattended-upgrades/20auto-upgrades /etc/apt/apt.conf.d/20auto-upgrades
    #sudo cp /usr/share/apt/apt.conf.d/90apt-clean /etc/apt/apt.conf.d/90apt-clean
}



# Function to configure automatic updates and clean up on Ubuntu
# - Installs and configures unattended-upgrades package
# - Frees up space if HDD is encrypted
# - Enables automatic installation of updates
# - Sets auto-remove unused dependencies after upgrade
# - Sets automatic cleanup of old packages
# - Sets automatic update of packages
# - Automatically reboots if necessary after upgrades
# - Sets reboot time if automatic reboot is enabled
# - Updates all packages and clean up after upgrade
# - Enables automatic updates
# - Configures automatic clean up of downloaded package files
# - Installs and configures logrotate to rotate log files

function configure_autoupdates() {
    clear
    if ! runWithLoading "Install unattended-upgrades package" "apt-get update" "install_package 'unattended-upgrades' "    "Error: Failed to install unattended upgrades!"; then
        exit 1
    fi

    if ! runWithLoading "Free Space if HDD is encrypted" "sudo lvextend -l +100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv" "Failed to extend the space."; then
        exit 1
    fi

    if ! runWithLoading "Free Space if HDD is encrypted" "sudo resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv" "Failed to resize the file system."; then
        exit 1
    fi

    if ! runWithLoading "Enabling automatic installation of updates" "sed -i 's,//Unattended-Upgrade::Allowed-Origins {/Unattended-Upgrade::Allowed-Origins {\n        \"${distro_id}:${distro_codename}-updates\";\n        \"${distro_id}:${distro_codename}-security\";\n        \"${distro_id}:${distro_codename}-proposed\";\n        \"${distro_id}:${distro_codename}-backports\";/g' /etc/apt/apt.conf.d/50unattended-upgrades" "Failed to enable automatic updates"; then
        exit 1
    fi

    if ! runWithLoading "Enable automatic security updates" \
    "sed -i 's,//\\s*\\(\\\"${distro_id}:${distro_codename}-security\\\";\\),\\1,' /etc/apt/apt.conf.d/50unattended-upgrades" \
    "Failed to enable automatic security updates"; then
        exit 1
    fi

    if ! runWithLoading "Set auto-remove unused dependencies after upgrade" "sed -i 's,//Unattended-Upgrade::Remove-Unused-Dependencies \"false\";,Unattended-Upgrade::Remove-Unused-Dependencies \"true\"; // Enables auto-remove unused dependencies after upgrade,' /etc/apt/apt.conf.d/50unattended-upgrades" "Failed to set autoremove after dependencies upgrade"; then
        exit 1
    fi

    if ! runWithLoading "Set automatic cleanup of old packages"  "echo 'APT::Periodic::AutocleanInterval \"7\"; // Sets automatic cleanup for old packages' | tee /etc/apt/apt.conf.d/20auto-upgrades" "Failed to set Automatic cleanup for old packages"; then
        exit 1
    fi

    if ! runWithLoading "Set automatic update of packages" "echo 'APT::Periodic::Update-Package-Lists \"1\"; // Sets automatic update of packages' | tee /etc/apt/apt.conf.d/20auto-upgrades" "Failed to set automatic update of packages"; then
        exit 1
    fi

    if ! runWithLoading "Automatically reboot if necessary after upgrades" "echo 'Unattended-Upgrade::Automatic-Reboot \"true\"; // Automatically reboots if necessary after upgrades' | tee -a /etc/apt/apt.conf.d/50unattended-upgrades" "Failed to enable automatic reboot on upgrades"; then
        exit 1
    fi

    if ! runWithLoading "Set reboot time if automatic reboot is enabled"  "echo 'Unattended-Upgrade::Automatic-Reboot-Time \"03:30\"; // Sets reboot time if automatic reboot is enabled' | tee -a /etc/apt/apt.conf.d/50unattended-upgrades" "Failed to enable Automatic reboot time"; then
        exit 1
    fi

    if ! runWithLoading "Enable automatic updates" "sudo dpkg-reconfigure -pmedium unattended-upgrades" "Failed to enable automatic updates"; then
        exit 1
    fi

    if ! runWithLoading "Automatically clean up downloaded package files" "echo 'APT::Clean-Installed \"true\"; // Configures automatic cleanup of downloaded package files' | tee /etc/apt/apt.conf.d/90apt-clean" "Failed to configure automatic clean up packages"; then
        exit 1
    fi

    if ! runWithLoading "Install and configure logrotate to rotate log files"  "install_package 'logrotate' "   "create_logrotate_file" "Failed to install and configure rotate log files"; then
        exit 1
    fi

    if ! runWithLoading "Enable automatic upgrades" \
    "echo 'APT::Periodic::Unattended-Upgrade \"1\"; // Enables automatic upgrades' | tee -a /etc/apt/apt.conf.d/20auto-upgrades" \
    "Failed to enable automatic upgrades"; then
        exit 1
    fi

    clear 

    echo "The Updates are now configured to Loco"
}



function auto_updates_cleanup() {
    system_cleanup
    restore_unattended_default
    configure_autoupdates
    logrotate
}