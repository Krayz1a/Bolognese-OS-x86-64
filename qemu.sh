#!/bin/bash

# Check if qemu-system-x86_64 is installed
if ! command -v qemu-system-x86_64 &> /dev/null; then
    echo "--> qemu-system-x86_64 is not installed. Attempting to install..."
    
    # Detect package manager and install
    if command -v apt-get &> /dev/null; then
        # Debian / Ubuntu / Linux Mint / WSL
        sudo apt-get update
        sudo apt-get install -y qemu-system-x86
    elif command -v pacman &> /dev/null; then
        # Arch Linux
        sudo pacman -S --noconfirm qemu-desktop
    elif command -v dnf &> /dev/null; then
        # Fedora
        sudo dnf install -y qemu-system-x86
    else
        echo "--> Error: Unsupported package manager. Please install QEMU manually."
        exit 1
    fi
    echo "--> QEMU installed successfully!"
fi

echo "--> Booting OS..."
qemu-system-x86_64 -m 2G -cdrom myos.iso -serial stdio -no-reboot
