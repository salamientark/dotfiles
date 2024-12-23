#!/bin/bash

# Update and instal necessary program
sudo apt update -y && sudo apt upgrade -y
yes | sudo apt install -y curl wget git zsh vim tree i3

# i3 Configuration
cp ./i3/config ~/.config/i3/config

#    ZSH
# Installing Oh My Zsh
exit | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cp ./zsh/.zshrc ~/.

# Installing fonts (For powerlevel10k)
echo "Installing fonts"
mkdir ~/.local/share/fonts
cp ./p10k/fonts/* ~/.local/share/fonts/.
fc-cache -f -v

# Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
cp ./p10k/.p10k.zsh ~/.

# Add zsh plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# NVIM
./nvim/install_nvim.sh

# Reload i3
i3-msg reload
i3-msg restart
