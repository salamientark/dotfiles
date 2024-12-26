# CHeck if neovim exist
nvim --version
if [ $? -eq 127 ]
then
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
fi

# Get Vim-Plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Get Vim npm for copilot
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
nvm install 22

# Clone config
mkdir ~/.config/nvim
git clone git@github.com:salamientark/nvim-config.git ~/.config/nvim

