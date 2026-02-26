#!/usr/bin/env bash
# Applications installation script

set -e

export AUR_HELPER="${AUR_HELPER:-paru}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

install_multimedia() {
    log_info "Installing multimedia apps..."
    
    $AUR_HELPER -S --noconfirm --needed \
        spotify-launcher \
        mpv
    
    log_info "Multimedia apps installed"
}

install_discord() {
    log_info "Installing Discord..."
    
    $AUR_HELPER -S --noconfirm --needed discord
    
    log_info "Discord installed"
}

install_obsidian() {
    log_info "Installing Obsidian..."
    
    $AUR_HELPER -S --noconfirm --needed obsidian
    
    log_info "Obsidian installed"
}

install_vpn() {
    log_info "Installing VPN client..."
    
    $AUR_HELPER -S --noconfirm --needed proton-vpn-gtk-app
    
    log_info "VPN client installed"
}

install_bleachbit() {
    log_info "Installing system tools..."
    
    sudo pacman -S --noconfirm --needed \
        bleachbit \
        gparted
    
    log_info "System tools installed"
}

install_file_manager() {
    log_info "Installing file managers..."
    
    $AUR_HELPER -S --noconfirm --needed \
        yazi \
        lf
    
    sudo pacman -S --noconfirm --needed nautilus
    
    log_info "File managers installed"
}

install_bluetooth() {
    log_info "Installing Bluetooth support..."
    
    sudo pacman -S --noconfirm --needed \
        bluez \
        bluez-utils \
        blueman
    
    sudo systemctl enable --now bluetooth
    
    log_info "Bluetooth installed"
}

install_printing() {
    log_info "Installing printing support..."
    
    sudo pacman -S --noconfirm --needed \
        cups \
        cups-pdf \
        system-config-printer
    
    sudo systemctl enable --now cups
    
    log_info "Printing support installed"
}

install_gtk_ themes() {
    log_info "Installing GTK themes..."
    
    $AUR_HELPER -S --noconfirm --needed \
        tokyonight-gtk-theme-git \
        catppuccin-gtk-theme-mocha \
        bibata-cursor-theme
    
    log_info "GTK themes installed"
}

main() {
    log_info "Starting applications installation..."
    
    install_multimedia
    install_discord
    install_obsidian
    install_vpn
    install_file_manager
    install_gtk_themes
    install_bluetooth
    install_printing
    
    log_info "Applications installation complete!"
}

main "$@"
