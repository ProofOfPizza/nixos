#!/run/current-system/sw/bin/bash

# Define the user's home directory
USER_HOME="/home/chai"

# Ensure the user's directories exist
mkdir -p "$USER_HOME/.config/scripts"
mkdir -p "$USER_HOME/.config/nvim/colors"
mkdir -p "$USER_HOME/.config/i3"
mkdir -p "$USER_HOME/.config/i3status"
mkdir -p "$USER_HOME/.vifm/scripts"
mkdir -p "$USER_HOME/.vifm/colors"

# Copy scripts
cp /etc/nixos/programs/scripts/batt-check.py "$USER_HOME/.config/scripts/batt-check.py"

# Copy Neovim configuration files
cp /etc/nixos/programs/editor/neovim/configs/SpaceMacs.vim "$USER_HOME/.config/nvim/colors/SpaceMacs.vim"
cp /etc/nixos/programs/editor/neovim/configs/coc-settings.json "$USER_HOME/.config/nvim/coc-settings.json"
cp /etc/nixos/programs/editor/neovim/configs/eslintrc.js "$USER_HOME/eslintrc.js"
cp /etc/nixos/programs/editor/neovim/init.vim "$USER_HOME/.config/nvim/init.vim"

# Copy i3 configuration files
cp /etc/nixos/programs/window-manager/i3/config "$USER_HOME/.config/i3/config"
cp /etc/nixos/programs/window-manager/i3/i3statusbar "$USER_HOME/.config/i3status/config"
cp /etc/nixos/programs/window-manager/i3/xrandr-2.sh "$USER_HOME/.config/i3/xrandr-2.sh"
cp /etc/nixos/programs/window-manager/i3/xrandr-1.sh "$USER_HOME/.config/i3/xrandr-1.sh"
cp /etc/nixos/programs/window-manager/i3/xrandr-1920.sh "$USER_HOME/.config/i3/xrandr-1920.sh"
cp /etc/nixos/programs/window-manager/i3/alacritty_start.sh "$USER_HOME/.config/i3/alacritty_start.sh"

# Copy vifm configuration files
cp /etc/nixos/programs/file-manager/vifm/vifmrc "$USER_HOME/.vifm/vifmrc"
cp /etc/nixos/programs/file-manager/vifm/scripts/vifmrun "$USER_HOME/.vifm/scripts/vifmrun"
cp /etc/nixos/programs/file-manager/vifm/scripts/vifmimg "$USER_HOME/.vifm/scripts/vifmimg"
cp /etc/nixos/programs/file-manager/vifm/colors/zenburn_1.vifm "$USER_HOME/.vifm/colors/zenburn_1.vifm"

# Copy .zshrc to the home directory
cp /etc/nixos/programs/shell/zsh/.zshrc "$USER_HOME/.zshrc"

# Copy Git configuration file
cp /etc/nixos/programs/git/git/gitconfig "$USER_HOME/.gitconfig"

# Set ownership to the correct user and group
chown -R chai:users "$USER_HOME/.config"
chown -R chai:users "$USER_HOME/.vifm"
chown chai:users "$USER_HOME/eslintrc.js"
chown chai:users "$USER_HOME/.gitconfig"
chown -R chai:users "$USER_HOME/.config/nvim"
chown chai:users "$USER_HOME/.zshrc"

