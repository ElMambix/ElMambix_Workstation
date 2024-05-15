#!/bin/bash

# Function to display messages in green color
print_success() {
    echo -e "\e[32m$1\e[0m"
}

# Function to display messages in red color
print_error() {
    echo -e "\e[31m$1\e[0m"
}

# Function to install a package
install_package() {
    sudo apt install -y "$1"
    if [ $? -eq 0 ]; then
        print_success "$1 installed successfully."
    else
        print_error "Failed to install $1. Please check your internet connection or try again later."
    fi
}

# Set hostname
sudo hostnamectl set-hostname --static shinobaso
sudo hostnamectl set-hostname --pretty "Miguel's Workstation"

# Update system
echo "Updating system..."
sudo apt update
sudo apt upgrade -y

# Add repository and install Mesa drivers
echo "Installing Mesa drivers..."
sudo add-apt-repository ppa:kisak/kisak-mesa
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y libgl1-mesa-dri:i386 mesa-vulkan-drivers mesa-vulkan-drivers:i386

# Install common packages
echo "Installing common packages..."
install_package "wget"
install_package "curl"
install_package "git"
install_package "vim"
install_package "gcc"
install_package "make"
install_package "python3"
install_package "python3-pip"

# Install Wine
echo "Installing Wine..."
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y wine64 wine32 libasound2-plugins:i386 libsdl2-2.0-0:i386 libdbus-1-3:i386 libsqlite3-0:i386

# Optimize AMD GPU
echo "Optimizing AMD GPU..."
echo 'options amdgpu si_support=1 cik_support=1' | sudo tee /etc/modprobe.d/amdgpu.conf

# Install Docker
echo "Installing Docker..."
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Add user to docker group
sudo usermod -aG docker $USER

# List of additional applications
LIST_OF_APPS="firefox timeshift bitwarden kate fish lutris wine winetricks gamescope steam docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"

# Install additional applications
echo "Installing additional applications..."
for app in $LIST_OF_APPS; do
    install_package "$app"
done

echo "All installations completed."
