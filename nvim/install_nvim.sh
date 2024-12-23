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

# Clone config
mkdir ~/.config/nvim
git clone git@github.com:salamientark/nvim-config.git ~/.config/nvim
