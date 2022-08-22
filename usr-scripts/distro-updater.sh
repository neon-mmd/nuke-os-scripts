#!/bin/env bash

# For debugging
# set -euo pipefail

echo "############################################################################" 
echo "########                   UPDATING NEON-OS                       ########" 
echo "############################################################################" 

internet_connectivity_error_message()
{
    echo "ERROR: It seems like you are not connected to the internet, Make sure you are connected and Try again."
    exit
}

internet_connection_check()
{
    ping -c 1 1.1.1.1 2> /dev/null 1> /dev/null || internet_connectivity_error_message 
}

internet_connection_check

configs_clone_install()
{
    internet_connection_check
    git clone https://gitlab.com/NEON-MMD/dotfiles.git
    cd dotfiles
}
configs_install()
{
    cd /tmp
    configs_clone_install || cd dotfiles
    sudo cp -rf .config/* ~/.config/ 1>/dev/null 2>/dev/null || doas -- cp -rf .config/* ~/.config/ 1>/dev/null 2>/dev/null 
    sudo cp -rf .imwheelrc ~/ 1>/dev/null 2>/dev/null || doas -- cp -rf .imwheelrc ~/ 1>/dev/null 2>/dev/null 
    sudo cp -rf .emacs.d/ ~/ 1>/dev/null 2>/dev/null || doas -- cp -rf .emacs.d/ ~/ 1>/dev/null 2>/dev/null 
    sudo cp -rf .bashrc ~/ 1>/dev/null 2>/dev/null || doas -- cp -rf .bashrc ~/ 1>/dev/null 2>/dev/null
    cd ..
    sudo rm -rf dotfiles 1>/dev/null 2>/dev/null || doas -- rm -rf dotfiles 1>/dev/null 2>/dev/null
}

configs_install || echo "ERROR: Failed to update"

