#!/bin/bash
# Function to print a message with a nice format
print_message() {
    echo -e "\n\033[1;34m==>\033[0m \033[1m$1\033[0m"
}

# Function to print an error message
print_error() {
    echo -e "\n\033[1;31m==> ERROR:\033[0m \033[1m$1\033[0m"
}

# Function to install a package
install_package() {
    local package=$1
    print_message "Installing $package..."
    if sudo pacman -S --noconfirm --needed $package; then
        print_message "$package installed successfully."
    else
        print_error "Failed to install $package."
        exit 1
    fi
}

# pacman
if [ -f /etc/pacman.conf ] && [ ! -f /etc/pacman.conf.t2.bkp ]; then
    print_message "Configuring pacman..."

    sudo cp /etc/pacman.conf /etc/pacman.conf.t2.bkp
    sudo sed -i "/^#Color/c\Color\nILoveCandy
    /^#VerbosePkgLists/c\VerbosePkgLists
    /^#ParallelDownloads/c\ParallelDownloads = 5" /etc/pacman.conf
    sudo sed -i '/^#\[multilib\]/,+1 s/^#//' /etc/pacman.conf

    sudo pacman -Syyu
    sudo pacman -Fy

else
    print_message "pacman is already configured..."
fi


# Function to install a package with pacman
install_package() {
    local package=$1
    print_message "Installing $package..."
    if sudo pacman -S --noconfirm --needed $package; then
        print_message "$package installed successfully."
    else
        print_error "Failed to install $package."
        exit 1
    fi
}

# Function to install a package with yay
install_aur_package() {
    local package=$1
    print_message "Installing AUR package $package..."
    if yay -S --noconfirm --needed $package; then
        print_message "$package installed successfully."
    else
        print_error "Failed to install $package."
        exit 1
    fi
}

# Function to load packages from a file
load_packages() {
    local package_file=$1
    if [[ ! -f "$package_file" ]]; then
        print_error "Package file $package_file not found."
        exit 1
    fi

    # Read the file line by line, ignoring comments and empty lines
    while IFS= read -r line; do
        # Remove comments and trim whitespace
        local package=$(echo "$line" | sed 's/#.*//' | xargs)
        if [[ -n "$package" ]]; then
            if [[ "$package" == aur:* ]]; then
                # Install AUR package (remove 'aur:' prefix)
                install_aur_package "${package#aur:}"
            else
                # Install official repository package
                install_package "$package"
            fi
        fi
    done < "$package_file"
}

# Function to install yay
install_yay() {
    print_message "Installing yay..."
    if ! command -v yay &> /dev/null; then
        print_message "Cloning yay repository..."
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        cd /tmp/yay
        makepkg -si --noconfirm
        cd -
        rm -rf /tmp/yay
        print_message "yay installed successfully."
    else
        print_message "yay is already installed."
    fi
}


# Install git and base-devel
install_package git
install_package base-devel

# Install yay
install_yay

# Load and install packages from the file
load_packages "packages.lst"

print_message "All packages installed successfully!"
