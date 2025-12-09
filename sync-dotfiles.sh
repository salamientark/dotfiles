#!/bin/bash
#
# sync-dotfiles.sh - Save important configs to ~/dotfiles
#
# Usage:
#   ./sync-dotfiles.sh           # Normal sync
#   ./sync-dotfiles.sh --dry-run # Preview changes without copying
#   ./sync-dotfiles.sh -v        # Verbose output
#   ./sync-dotfiles.sh --help    # Show help
#

# Note: Not using 'set -e' to allow graceful error handling

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DOTFILES_DIR="$HOME/dotfiles"
DRY_RUN=false
VERBOSE=false
COPIED_COUNT=0
SKIPPED_COUNT=0
ERROR_COUNT=0

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run|-n)
            DRY_RUN=true
            shift
            ;;
        --verbose|-v)
            VERBOSE=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --dry-run, -n    Preview changes without copying"
            echo "  --verbose, -v    Show detailed output"
            echo "  --help, -h       Show this help message"
            echo ""
            echo "Syncs important config files from home directory to ~/dotfiles"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

# Print functions
print_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
    ((ERROR_COUNT++))
}

print_info() {
    if [[ "$VERBOSE" == true ]]; then
        echo -e "  $1"
    fi
}

# Sync function
sync_file() {
    local source="$1"
    local dest="$2"
    local description="$3"
    
    # Check if source exists
    if [[ ! -e "$source" ]]; then
        print_warning "Source not found: $source"
        ((SKIPPED_COUNT++))
        return
    fi
    
    # Create destination directory if needed
    local dest_dir=$(dirname "$dest")
    if [[ ! -d "$dest_dir" ]]; then
        if [[ "$DRY_RUN" == false ]]; then
            mkdir -p "$dest_dir"
            print_info "Created directory: $dest_dir"
        else
            print_info "[DRY-RUN] Would create directory: $dest_dir"
        fi
    fi
    
    # Check if files differ
    if [[ -e "$dest" ]]; then
        if diff -q "$source" "$dest" &>/dev/null; then
            print_info "Up-to-date: $description"
            ((SKIPPED_COUNT++))
            return
        fi
    fi
    
    # Copy the file/directory
    if [[ "$DRY_RUN" == false ]]; then
        if [[ -d "$source" ]]; then
            cp -r "$source"/* "$dest/" 2>/dev/null || cp -r "$source" "$dest_dir/"
            print_success "Synced: $description"
        else
            cp "$source" "$dest"
            print_success "Synced: $description"
        fi
        ((COPIED_COUNT++))
    else
        print_success "[DRY-RUN] Would sync: $description"
        ((COPIED_COUNT++))
    fi
}

sync_directory() {
    local source="$1"
    local dest="$2"
    local description="$3"
    local exclude_pattern="$4"
    
    # Check if source exists
    if [[ ! -d "$source" ]]; then
        print_warning "Source directory not found: $source"
        ((SKIPPED_COUNT++))
        return
    fi
    
    # Create destination if needed
    if [[ ! -d "$dest" ]]; then
        if [[ "$DRY_RUN" == false ]]; then
            mkdir -p "$dest"
            print_info "Created directory: $dest"
        else
            print_info "[DRY-RUN] Would create directory: $dest"
            ((COPIED_COUNT++))
            return
        fi
    fi
    
    # Check if rsync is available, otherwise use cp
    if command -v rsync &> /dev/null; then
        # Use rsync for directory syncing with exclusions
        local rsync_opts="-a --delete"
        if [[ "$VERBOSE" == true ]]; then
            rsync_opts="$rsync_opts -v"
        else
            rsync_opts="$rsync_opts -q"
        fi
        if [[ "$DRY_RUN" == true ]]; then
            rsync_opts="$rsync_opts --dry-run"
        fi
        if [[ -n "$exclude_pattern" ]]; then
            rsync_opts="$rsync_opts --exclude='$exclude_pattern'"
        fi
        
        if rsync $rsync_opts "$source/" "$dest/"; then
            print_success "Synced directory: $description"
            ((COPIED_COUNT++))
        else
            print_error "Failed to sync: $description"
        fi
    else
        # Fallback to cp-based sync
        if [[ "$DRY_RUN" == false ]]; then
            # Remove old destination and copy fresh
            rm -rf "$dest"
            mkdir -p "$dest"
            
            # Copy with exclusions
            if [[ -n "$exclude_pattern" ]]; then
                # Use find to copy while excluding pattern
                (cd "$source" && find . -type f ! -name "$exclude_pattern" -exec sh -c 'mkdir -p "'"$dest"'/$(dirname "$1")" && cp "$1" "'"$dest"'/$1"' _ {} \;)
            else
                cp -r "$source"/* "$dest"/
            fi
            print_success "Synced directory: $description"
            ((COPIED_COUNT++))
        else
            print_success "[DRY-RUN] Would sync directory: $description"
            ((COPIED_COUNT++))
        fi
    fi
}

# Main script
main() {
    print_header "Dotfiles Sync Script"
    
    if [[ "$DRY_RUN" == true ]]; then
        print_warning "DRY-RUN MODE: No files will be modified"
    fi
    
    # Validate dotfiles directory exists
    if [[ ! -d "$DOTFILES_DIR" ]]; then
        print_error "Dotfiles directory not found: $DOTFILES_DIR"
        exit 1
    fi
    
    cd "$DOTFILES_DIR" || exit 1
    print_success "Working in: $DOTFILES_DIR"
    
    # Check for uncommitted changes
    if [[ -d .git ]]; then
        if ! git diff-index --quiet HEAD -- 2>/dev/null; then
            print_warning "Dotfiles repo has uncommitted changes"
        fi
    fi
    
    print_header "Syncing Configuration Files"
    
    # i3 window manager
    sync_directory "$HOME/.config/i3" "$DOTFILES_DIR/i3" "i3 config" "*.backup"
    
    # i3blocks status bar
    sync_directory "$HOME/.config/i3blocks" "$DOTFILES_DIR/i3blocks" "i3blocks config" ""
    
    # picom compositor
    sync_directory "$HOME/.config/picom" "$DOTFILES_DIR/picom" "picom config" ""
    
    # polybar status bar
    sync_directory "$HOME/.config/polybar" "$DOTFILES_DIR/polybar" "polybar config" ""
    
    # Zsh configuration
    sync_file "$HOME/.zshrc" "$DOTFILES_DIR/zsh/.zshrc" "zsh config"
    
    # Powerlevel10k theme
    sync_file "$HOME/.p10k.zsh" "$DOTFILES_DIR/p10k/.p10k.zsh" "p10k theme"
    
    # OpenCode agent configs
    sync_directory "$HOME/.config/opencode/agent" "$DOTFILES_DIR/opencode/agent" "opencode agents" ""
    sync_file "$HOME/.config/opencode/opencode.json" "$DOTFILES_DIR/opencode/opencode.json" "opencode config"
    
    # Fonts (only if destination is empty or missing)
    if [[ ! -d "$DOTFILES_DIR/fonts" ]] || [[ -z "$(ls -A "$DOTFILES_DIR/fonts" 2>/dev/null)" ]]; then
        print_info "Fonts directory empty or missing, syncing fonts..."
        if [[ -d "$HOME/.local/share/fonts" ]]; then
            sync_directory "$HOME/.local/share/fonts" "$DOTFILES_DIR/fonts" "fonts" ""
        fi
    else
        print_info "Fonts already present, skipping"
        ((SKIPPED_COUNT++))
    fi
    
    # Alacritty (if exists in home)
    if [[ -d "$HOME/.config/alacritty" ]]; then
        sync_directory "$HOME/.config/alacritty" "$DOTFILES_DIR/alacritty" "alacritty config" ""
    else
        print_info "Alacritty config not found in ~/.config, skipping"
        ((SKIPPED_COUNT++))
    fi
    
    # st (simple terminal) - already in dotfiles, no sync needed
    print_info "st config already in dotfiles"
    
    print_header "Summary"
    echo -e "${GREEN}Synced:${NC}  $COPIED_COUNT file(s)"
    echo -e "${YELLOW}Skipped:${NC} $SKIPPED_COUNT file(s)"
    if [[ $ERROR_COUNT -gt 0 ]]; then
        echo -e "${RED}Errors:${NC}  $ERROR_COUNT"
        exit 1
    fi
    
    if [[ "$DRY_RUN" == false ]]; then
        print_success "Sync completed successfully!"
        echo ""
        echo "Next steps:"
        echo "  cd $DOTFILES_DIR"
        echo "  git status           # Review changes"
        echo "  git add -A           # Stage all changes"
        echo "  git commit -m 'Update configs'  # Commit"
        echo "  git push             # Push to remote"
    else
        print_warning "Dry-run completed. Run without --dry-run to apply changes."
    fi
}

# Run main function
main
