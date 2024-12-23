# Personnal configuration
This is my personnal configuration.
I'm actually using Ubuntu with :
- I3wm as window manager
- Zsh + powerlevel10k as terminal and theme
- neovim as code editor

## Install
Run :
```
git clone git@github.com:salamientark/Full-config.git && cd Full-config && sudo -u $(whoami) ./install.sh
```
## Configuration
### NVIM
On launch do
1. ```
:PlugInstall
```
Reapeat until it succeed
2. ```
:Mason
```
Wait until all languages are installed

To configure Copilot
