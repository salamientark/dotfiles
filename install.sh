#!/bin/bash

# Update and install necessary program
sudo apt update -y && sudo apt upgrade -y
yes | sudo apt install -y curl wget git zsh vim tree i3 clang gcc lldb xsel bat

###    i3 Configuration    ###
cp ./i3/config ~/.config/i3/config

###    ZSH    ###
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

###    NVIM    ###
# Check if user can be a superUser 
sudo -v 
if [ $? -eq 0 ] 
then 
        SU=true 
else 
        SU=false 
fi 
 
# Install Nvim and add configuration 
# Clone the repo 
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz 
 
# Extract Files 
if [ $SU = true ] 
then 
        sudo rm -rf /opt/nvim && sudo mkdir /opt; sudo tar -C /opt -xzf nvim-linux64.tar.gz && NVIM_PATH=/opt 
else 
        mkdir ~/TOOLS && tar -C ~/TOOLS -xzf nvim-linux64.tar.gz && NVIM_PATH=$(env | grep "HOME=" | sed -e "s/HOME=//")/TOOLS 
fi 
 
# Export PATH 
echo 'export PATH='"$PATH:$NVIM_PATH/nvim-linux64/bin" >> ~/.zshrc 

# Downaload vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install npm for github copilot
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
source ~/.zshrc
nvm install 22

# Clone config 
mkdir ~/.config/nvim 
git clone git@github.com:salamientark/nvim-config.git ~/.config/nvim 

# Remove archive
rm nvim-linux64.tar.gz

###    Reload i3    ###
i3-msg reload
i3-msg restart
