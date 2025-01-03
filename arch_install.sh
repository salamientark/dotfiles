#!/bin/bash

# Update and install necessary program
sudo pacman -Sy curl wget git vim tree clang gcc lldb xsel bat eza firefox \
	xorg xorg-xinit i3 dmenu alacritty picom feh

###    i3 Configuration    ###
echo "Copying i3 configuration"
cp -r ./i3/ ~/.config/.
echo "Copying i3blocks configuration"
cp -r ./i3blocks/ ~/.config/.
echo "Copying picom configuration"
cp -r ./picom/ ~/.config/.
echo "Copying alacritty configuration"
cp -r ./alacritty/ ~/.config/.

# Installing fonts (For powerlevel10k)
echo "Installing fonts"
mkdir ~/.local/share/fonts
cp ./fonts/* ~/.local/share/fonts/.
fc-cache -f -v

###    ZSH    ###
echo "Installing OhMyZsh"
# Installing Oh My Zsh
exit | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo "Copying zsh configuration"
cp ./zsh/.zshrc ~/.

# Powerlevel10k
echo "Installing Powerlevel10k"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
echo "Copying Powerlevel10k configuration"
cp ./p10k/.p10k.zsh ~/.

# Add zsh plugins
echo "Adding zsh plugins"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

###    NVIM    ###
# Download vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install npm for github copilot
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
source ~/.zshrc
nvm install 22

# Clone config 
mkdir ~/.config/nvim 
git clone https://github.com/salamientark/nvim-config.git ~/.config/nvim 


###   Start Xsession   ###
echo "Starting i3 on login"
echo "#!/bin/bash
exec i3" > ~/.xinitrc
chmod +x ~/.xinitrc
startx
