# Backs up the ssh configuration file
# Defines a sub-function to uncomment or change the value of an option in the ssh configuration file
# Calls the sub-function for each configuration option to be modified:
# Uncomment or set the option 'PasswordAuthentication' to 'no'
# Set the option 'PermitEmptyPasswords' to 'no'
# Set the option 'PubkeyAuthentication' to 'yes'
# Reloads the ssh service
# Prompts the user if they want to change the password for the current user
# Prompts the user if they want to add a known SSH key
# If the user chooses to add a known SSH key, it prompts the user for the key and appends it to the authorized_keys file of the current user's SSH directory.

function ssh_security {
    # Backup the ssh config
    sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

    # Function to uncomment or change a value in the sshd_config file
    uncomment_or_change() {
        local pattern="$1"
        local new_value="$2"
        if grep -q "^#$pattern" /etc/ssh/sshd_config; then
            # If the line is commented, uncomment it
            sudo sed -i "s/^#$pattern/$new_value/" /etc/ssh/sshd_config
        elif grep -q "^$pattern" /etc/ssh/sshd_config; then
            # If the line is not commented, change the value
            sudo sed -i "s/^$pattern.*/$new_value/" /etc/ssh/sshd_config
        else
            # If the line does not exist, append it to the end of the file
            sudo sh -c "echo '$new_value' >> /etc/ssh/sshd_config"
        fi
    }

    # Call the function for each configuration option
    uncomment_or_change "PasswordAuthentication yes" "PasswordAuthentication no"
    uncomment_or_change "PermitEmptyPasswords no" "PermitEmptyPasswords no"
    uncomment_or_change "PubkeyAuthentication yes" "PubkeyAuthentication yes"

    # Restart the ssh service
    sudo systemctl reload ssh

    echo "SSH hardened!"

    read -p "Current user is $SUDO_USER, do you want to change your user password? (y/n): " change_password

    if [[ $change_password == "y" ]]; then
        passwd "$SUDO_USER"
    fi

    read -p "Do you want to add a known SSH key? (y/n): " add_ssh_key

    if [[ $add_ssh_key == "y" ]]; then
        read -p "Enter the SSH public key: " ssh_key
        sudo -u $SUDO_USER sh -c "echo \"$ssh_key\" >> ~/.ssh/authorized_keys"
        echo "Key added"
        sudo systemctl reload ssh
    fi
}
