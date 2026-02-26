#!/usr/bin/env bash
# Hyprland + UI Stack installation script

set -e

export AUR_HELPER="${AUR_HELPER:-paru}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

install_wayland_deps() {
    log_info "Installing Wayland dependencies..."
    
    sudo pacman -S --noconfirm --needed \
        wayland \
        wayland-protocols \
        xorg-xwayland \
        xorg-xlsclients
    
    log_info "Wayland dependencies installed"
}

install_hyprland() {
    log_info "Installing Hyprland..."
    
    $AUR_HELPER -S --noconfirm --needed \
        hyprland \
        xdg-desktop-portal-hyprland \
        qt5-wayland \
        qt6-wayland
    
    log_info "Hyprland installed"
}

install_ui_tools() {
    log_info "Installing UI tools..."
    
    $AUR_HELPER -S --noconfirm --needed \
        waybar \
        wofi \
        mako \
        swaybg \
        swaylock-effects-git \
        polkit-gnome \
        nwg-look \
        papirus-icon-theme-git
    
    log_info "UI tools installed"
}

install_fonts() {
    log_info "Installing fonts..."
    
    sudo pacman -S --noconfirm --needed \
        ttf-jetbrains-mono \
        ttf-jetbrains-mono-nerd \
        noto-fonts \
        noto-fonts-emoji
    
    $AUR_HELPER -S --noconfirm --needed \
        ttf-jetbrains-mono-nerd
    
    log_info "Fonts installed"
}

install_terminal() {
    log_info "Installing terminal emulator..."
    
    $AUR_HELPER -S --noconfirm --needed ghostty
    
    log_info "Terminal installed"
}

main() {
    log_info "Starting Hyprland + UI stack installation..."
    
    install_wayland_deps
    install_hyprland
    install_ui_tools
    install_fonts
    install_terminal
    
    log_info "Hyprland installation complete!"
    log_info "Log out and select Hyprland from your display manager"
}

main "$@"
