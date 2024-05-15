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
    sudo dnf install -y "$1"
    if [ $? -eq 0 ]; then
        print_success "$1 installed successfully."
    else
        print_error "Failed to install $1. Please check your internet connection or try again later."
    fi
}

sudo hostnamectl set-hostname --static shinobaso
sudo hostnamectl set-hostname --pretty "Miguel's Workstation"

# Update system
echo "Updating system..."
sudo dnf update -y

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

# List of additional applications
LIST_OF_APPS="firefox bitwarden kate fish lutris wine winetricks gamescope steam docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"

# Install additional applications
echo "Installing additional applications..."
for app in $LIST_OF_APPS; do
    install_package "$app"
done

echo "All installations completed."
