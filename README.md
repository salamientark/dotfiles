# Personal Dotfiles

Configuration files for my Linux development environment.

## Contents

- **i3** - Window manager configuration
- **i3blocks** - Status bar configuration  
- **picom** - Compositor for transparency effects
- **zsh** - Shell configuration with Oh My Zsh
- **p10k** - Powerlevel10k theme for zsh
- **alacritty** - Terminal emulator config
- **fonts** - MesloLGS NF fonts for p10k
- **st** - Simple terminal build config
- **nvim** - Neovim configuration
- **opencode** - OpenCode AI agent configurations

## Installation

### Quick Install (Ubuntu/Debian)
```bash
cd ~/dotfiles
./install.sh
```

### Manual Sync
To sync your current configs to this dotfiles repo:
```bash
./sync-dotfiles.sh          # Sync configs from ~ to ~/dotfiles
./sync-dotfiles.sh --dry-run   # Preview changes without copying
./sync-dotfiles.sh --verbose   # Show detailed output
```

The sync script will copy the following from your home directory:
- `~/.config/i3/` → `i3/`
- `~/.config/i3blocks/` → `i3blocks/`
- `~/.config/picom/` → `picom/`
- `~/.config/opencode/agent/` → `opencode/agent/`
- `~/.config/opencode/opencode.json` → `opencode/opencode.json`
- `~/.zshrc` → `zsh/.zshrc`
- `~/.p10k.zsh` → `p10k/.p10k.zsh`
- `~/.local/share/fonts/` → `fonts/` (if missing)

After syncing, review and commit changes:
```bash
git status
git add -A
git commit -m "Update configs"
git push
```

## Nvim Setup

### Install Neovim Config
```bash
rm -rf ~/.config/nvim
git clone git@github.com:salamientark/nvim-config.git ~/.config/nvim
cd ~/.config/nvim
./install.sh
```

### First-time Setup
When starting nvim for the first time:
```
:PlugInstall  # Install plugins
:Mason        # Install language servers
:Copilot setup  # Setup GitHub Copilot
```

## Important Notes

### System-Specific Settings
You may need to adjust these based on your setup:

- **DPI settings**: Edit `~/.Xresources`
- **Display scaling**: Edit `~/.config/i3/config` (xrandr scale setting)
- **Time zone**: Edit `~/.config/i3blocks/i3blocks.conf`

### i3 Configuration
The i3 config uses `bindcode` instead of `bindsym` for keyboard layout independence (works with both QWERTY and AZERTY layouts).

### Keyboard Layouts
Current i3 config is compatible with:
- QWERTY
- AZERTY

The bindcode approach ensures keybindings work regardless of your keyboard layout.

## Dependencies

Main packages required:
```bash
# Core utilities
sudo apt install -y curl wget git zsh vim tree clang gcc lldb xsel bat eza

# Window manager and tools
sudo apt install -y i3 i3blocks picom feh

# Optional
sudo apt install -y alacritty  # Terminal emulator
```

## License

Personal configuration files - feel free to use and modify as needed.
