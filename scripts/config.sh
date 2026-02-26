#!/usr/bin/env bash
# Configuration files setup script

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONF_DIR="$(cd "$SCRIPT_DIR/../conf" && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

backup_existing() {
    local file="$1"
    if [[ -f "$file" ]] || [[ -d "$file" ]]; then
        mv "$file" "${file}.backup.$(date +%Y%m%d%H%M%S)"
        log_info "Backed up existing $file"
    fi
}

setup_directories() {
    log_info "Creating config directories..."
    
    mkdir -p ~/.config/{hypr,waybar,wofi,mako,ghostty,nvim,fish}
    mkdir -p ~/Pictures/wallpapers
    mkdir -p ~/.local/bin
    
    log_info "Directories created"
}

setup_hyprland() {
    log_info "Setting up Hyprland config..."
    
    backup_existing ~/.config/hypr
    cp -r "$CONF_DIR/hypr" ~/.config/
    
    log_info "Hyprland config set up"
}

setup_waybar() {
    log_info "Setting up Waybar config..."
    
    backup_existing ~/.config/waybar
    cp -r "$CONF_DIR/waybar" ~/.config/
    cp "$CONF_DIR/waybar/style.css" ~/.config/waybar/
    
    log_info "Waybar config set up"
}

setup_wofi() {
    log_info "Setting up Wofi config..."
    
    backup_existing ~/.config/wofi
    cp -r "$CONF_DIR/wofi" ~/.config/
    
    log_info "Wofi config set up"
}

setup_mako() {
    log_info "Setting up Mako config..."
    
    backup_existing ~/.config/mako
    cp -r "$CONF_DIR/mako" ~/.config/
    
    log_info "Mako config set up"
}

setup_ghostty() {
    log_info "Setting up Ghostty config..."
    
    backup_existing ~/.config/ghostty
    cp -r "$CONF_DIR/ghostty" ~/.config/
    
    log_info "Ghostty config set up"
}

setup_fish() {
    log_info "Setting up Fish shell config..."
    
    backup_existing ~/.config/fish
    cp -r "$CONF_DIR/fish" ~/.config/
    
    if ! grep -q "fish" /etc/shells; then
        echo "/usr/bin/fish" | sudo tee -a /etc/shells
    fi
    
    log_info "Fish config set up"
}

setup_nvim() {
    log_info "Setting up Neovim..."
    
    if [[ -d ~/.config/nvim ]]; then
        backup_existing ~/.config/nvim
    fi
    
    git clone https://github.com/NvChad/starter ~/.config/nvim
    
    log_info "Neovim set up - run 'nvim +LazySync' after first launch"
}

setup_mise() {
    log_info "Setting up mise..."
    
    if command -v mise &> /dev/null; then
        mise use -g node python java rust
    else
        log_warn "mise not installed yet - run after dev.sh"
    fi
    
    log_info "Mise configured"
}

setup_wallpaper() {
    log_info "Downloading wallpaper..."
    
    if [[ ! -f ~/Pictures/wallpapers/tokyo-night.png ]]; then
        wget -q -O ~/Pictures/wallpapers/tokyo-night.png \
            "https://github.com/folke/tokyonight.nvim/blob/main/extras/wallpaper/tokyo-night.png?raw=true"
    fi
    
    log_info "Wallpaper set up"
}

setup_hyprlock() {
    log_info "Setting up hyprlock..."
    
    mkdir -p ~/.config/hypr
    
    if [[ ! -f ~/.config/hypr/hyprlock.conf ]]; then
        cat > ~/.config/hypr/hyprlock.conf << 'EOF'
general {
    grace = 5
    hide_cursor = true
}

background {
    path = ~/Pictures/wallpapers/tokyo-night.png
    blur_passes = 2
    blur_size = 4
}

input-field {
    size = 250, 50
    outline_thickness = 2
    fade_on_empty = false
    placeholder_text = Password...
}
EOF
    fi
    
    log_info "Hyprlock configured"
}

setup_autostart() {
    log_info "Setting up autostart applications..."
    
    mkdir -p ~/.config/hypr
    
    if [[ ! -f ~/.config/hypr/autostart.conf ]]; then
        cat > ~/.config/hypr/autostart.conf << 'EOF'
exec-once = waybar &
exec-once = mako &
exec-once = swaybg -m fill -i ~/Pictures/wallpapers/tokyo-night.png &
exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
exec-once = discord &
exec-once = spotify &
EOF
    fi
    
    log_info "Autostart configured"
}

main() {
    log_info "Starting configuration setup..."
    
    setup_directories
    setup_hyprland
    setup_waybar
    setup_wofi
    setup_mako
    setup_ghostty
    setup_fish
    setup_nvim
    setup_wallpaper
    setup_hyprlock
    setup_autostart
    
    log_info "Configuration complete!"
    log_info "Log out and log back in to apply changes"
    log_info "For Fish shell: chsh -s /usr/bin/fish"
    log_info "For Hyprland: select from display manager"
}

main "$@"
