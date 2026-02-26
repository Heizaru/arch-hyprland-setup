#!/usr/bin/env bash
# Base system setup script

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export AUR_HELPER="${AUR_HELPER:-paru}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

check() {
    command -v "$1" &> /dev/null
}

install_aur_helper() {
    if check "$AUR_HELPER"; then
        log_info "$AUR_HELPER already installed"
        return 0
    fi
    
    log_info "Installing $AUR_HELPER..."
    
    local temp_dir
    temp_dir=$(mktemp -d)
    cd "$temp_dir"
    
    git clone --depth 1 "https://aur.archlinux.org/${AUR_HELPER}.git"
    cd "$AUR_HELPER"
    makepkg -si --noconfirm --needed
    
    cd /
    rm -rf "$temp_dir"
    
    log_info "$AUR_HELPER installed successfully"
}

setup_mirrors() {
    log_info "Setting up fastest mirrors with reflector..."
    
    if ! check reflector; then
        sudo pacman -S --noconfirm --needed reflector
    fi
    
    sudo reflector --latest 20 --sort rate --save /etc/pacman.d/mirrorlist
    log_info "Mirrors optimized"
}

setup_caching() {
    log_info "Setting up pacman cache timer..."
    
    if ! check pacman-contrib; then
        sudo pacman -S --noconfirm --needed pacman-contrib
    fi
    
    sudo systemctl enable --now paccache.timer
    log_info "Cache cleanup enabled"
}

setup_firewall() {
    log_info "Configuring UFW firewall..."
    
    if ! check ufw; then
        sudo pacman -S --noconfirm --needed ufw
    fi
    
    sudo systemctl enable --now ufw
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw enable
    
    log_info "Firewall configured"
}

install_snapshot_tools() {
    log_info "Installing snapshot tools..."
    
    $AUR_HELPER -S --noconfirm --needed snapper snap-pac grub-btrfs
    
    log_info "Snapshot tools installed"
}

install_base_devel() {
    log_info "Installing base-devel and git..."
    sudo pacman -S --noconfirm --needed base-devel git curl wget
}

main() {
    log_info "Starting base system setup..."
    
    install_base_devel
    install_aur_helper
    
    log_info "Updating system..."
    sudo pacman -Syu --noconfirm
    
    setup_mirrors
    setup_caching
    setup_firewall
    install_snapshot_tools
    
    log_info "Base system setup complete!"
}

main "$@"
