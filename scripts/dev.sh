#!/usr/bin/env bash
# Development tools installation script

set -e

export AUR_HELPER="${AUR_HELPER:-paru}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

install_shell_tools() {
    log_info "Installing shell tools..."
    
    $AUR_HELPER -S --noconfirm --needed \
        fish \
        starship \
        zoxide \
        fzf \
        bat \
        eza \
        btop
    
    log_info "Shell tools installed"
}

install_nvim() {
    log_info "Installing Neovim..."
    
    $AUR_HELPER -S --noconfirm --needed neovim-git
    
    log_info "Neovim installed"
}

install_mise() {
    log_info "Installing mise..."
    
    $AUR_HELPER -S --noconfirm --needed mise-bin
    
    log_info "Mise installed"
}

install_vscode() {
    log_info "Installing VS Code..."
    
    $AUR_HELPER -S --noconfirm --needed visual-studio-code-bin
    
    log_info "VS Code installed"
}

install_git_tools() {
    log_info "Installing git tools..."
    
    $AUR_HELPER -S --noconfirm --needed \
        lazygit \
        git-delta
    
    sudo pacman -S --noconfirm --needed git gh
    
    log_info "Git tools installed"
}

install_docker() {
    log_info "Installing Docker..."
    
    sudo pacman -S --noconfirm --needed \
        docker \
        docker-compose
    
    $AUR_HELPER -S --noconfirm --needed lazydocker
    
    sudo systemctl enable --now docker
    sudo usermod -aG docker "$USER"
    
    log_info "Docker installed (may require re-login)"
}

install_utils() {
    log_info "Installing utilities..."
    
    sudo pacman -S --noconfirm --needed \
        ripgrep \
        fd \
        unzip \
        jq \
        yq \
        wget \
        curl \
        lsd
    
    $AUR_HELPER -S --noconfirm --needed \
        lsd
    
    log_info "Utilities installed"
}

install_browsers() {
    log_info "Installing browsers..."
    
    $AUR_HELPER -S --noconfirm --needed brave-bin
    
    log_info "Browsers installed"
}

install_api_tools() {
    log_info "Installing API tools..."
    
    $AUR_HELPER -S --noconfirm --needed bruno-bin
    
    log_info "API tools installed"
}

main() {
    log_info "Starting development tools installation..."
    
    install_shell_tools
    install_mise
    install_nvim
    install_vscode
    install_git_tools
    install_docker
    install_utils
    install_browsers
    install_api_tools
    
    log_info "Development tools installation complete!"
    log_info "Run 'mise use -g node python java' to install runtimes"
}

main "$@"
