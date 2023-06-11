#Function to install packages e.g. install_package "vim"

function install_package() {
    sudo apt-get -y install "$1"
}


# Function to install qemu-agent if user prompted Yes
function install_qemu(){
         # Perform Qemu Agent install
        read -p "Qemu Agent not found, would you like to install it? [y/n] " -n 1 -r
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        clear
        loadingAnimation "Installing Qemu Agent please wait..."
        echo -e "\rSet Installing Qemu Agent please wait..."
            sudo apt-get install qemu-guest-agent -y > /dev/null 2>&1
            sudo systemctl start qemu-guest-agent > /dev/null 2>&1
            sudo systemctl enable qemu-guest-agent > /dev/null 2>&1
        echo "Qemu Agent Installed"
        fi
}

# Function to install docker if user prompted Yes
function install_docker(){
         # Perform docker install
        read -p "Docker not found, would you like to install docker? [y/n] " -n 1 -r
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        clear
        loadingAnimation "Installing Docker please wait..."
        echo -e "\rSet Installing Docker please wait..."
            curl -fsSL https://get.docker.com -o get-docker.sh
            sh get-docker.sh > /dev/null 2>&1
        echo "Docker Installed"
        fi
}