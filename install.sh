#!/usr/bin/env bash
# Arch Hyprland Setup - Main Installer
# Usage: curl -sL https://your-repo/install.sh | bash
# Or clone and run: ./install.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

usage() {
    cat <<EOF
Arch Hyprland Setup Installer

Usage: $0 [OPTIONS]

OPTIONS:
    -h, --help              Show this help message
    --skip-base             Skip base system setup
    --skip-hyprland         Skip Hyprland installation
    --skip-dev              Skip dev tools
    --skip-apps             Skip applications
    --skip-config           Skip config files
    --all                   Run all steps (default)
    --minimal               Only base + hyprland (no apps/dev)

EXAMPLES:
    $0                      # Run full setup
    $0 --minimal            # Base + Hyprland only
    $0 --skip-apps          # Skip Discord, Spotify, etc.

EOF
}

SKIP_BASE=false
SKIP_HYPRLAND=false
SKIP_DEV=false
SKIP_APPS=false
SKIP_CONFIG=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help) usage; exit 0 ;;
        --skip-base) SKIP_BASE=true; shift ;;
        --skip-hyprland) SKIP_HYPRLAND=true; shift ;;
        --skip-dev) SKIP_DEV=true; shift ;;
        --skip-apps) SKIP_APPS=true; shift ;;
        --skip-config) SKIP_CONFIG=true; shift ;;
        --all) shift ;;
        --minimal) SKIP_DEV=true; SKIP_APPS=true; shift ;;
        *) log_error "Unknown option: $1"; usage; exit 1 ;;
    esac
done

check_root() {
    if [[ $EUID -eq 0 ]]; then
        log_error "This script should NOT be run as root"
        exit 1
    fi
}

check_aur_helper() {
    if command -v "$AUR_HELPER" &> /dev/null || command -v yay &> /dev/null; then
        return 0
    fi
    log_warn "No AUR helper found. Will install $AUR_HELPER in base.sh"
}

check_hyprland() {
    if [[ -z "$WAYLAND_DISPLAY" ]] && [[ "$(whoami)" != "root" ]]; then
        log_warn "Not in a Wayland session. You'll need to log out and log back in."
    fi
}

export AUR_HELPER="${AUR_HELPER:-paru}"

run_script() {
    local script="$1"
    local description="$2"
    
    if [[ "$script" == "base.sh" ]] && [[ "$SKIP_BASE" == true ]]; then
        log_warn "Skipping $description"
        return 0
    fi
    if [[ "$script" == "hyprland.sh" ]] && [[ "$SKIP_HYPRLAND" == true ]]; then
        log_warn "Skipping $description"
        return 0
    fi
    if [[ "$script" == "dev.sh" ]] && [[ "$SKIP_DEV" == true ]]; then
        log_warn "Skipping $description"
        return 0
    fi
    if [[ "$script" == "apps.sh" ]] && [[ "$SKIP_APPS" == true ]]; then
        log_warn "Skipping $description"
        return 0
    fi
    if [[ "$script" == "config.sh" ]] && [[ "$SKIP_CONFIG" == true ]]; then
        log_warn "Skipping $description"
        return 0
    fi
    
    log_info "Running: $description"
    bash "${SCRIPT_DIR}/scripts/${script}"
}

main() {
    log_info "Arch Hyprland Setup starting..."
    log_info "AUR Helper: $AUR_HELPER"
    
    check_root
    check_aur_helper
    
    if [[ "$SKIP_BASE" == false ]]; then
        run_script "base.sh" "Base system setup"
    fi
    
    if [[ "$SKIP_HYPRLAND" == false ]]; then
        run_script "hyprland.sh" "Hyprland + UI stack"
    fi
    
    if [[ "$SKIP_DEV" == false ]]; then
        run_script "dev.sh" "Development tools"
    fi
    
    if [[ "$SKIP_APPS" == false ]]; then
        run_script "apps.sh" "Applications"
    fi
    
    if [[ "$SKIP_CONFIG" == false ]]; then
        run_script "config.sh" "Configuration files"
    fi
    
    log_info "Setup complete! Please reboot and select Hyprland from your display manager."
    log_info "After logging in, run: nvim +'LazySync' to sync plugins"
}

main "$@"
