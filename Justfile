# catppuccin-onedark-tmux task runner

# List available recipes
default:
    just --list

# Reload tmux config (sources catppuccin + onedark overlay)
reload:
    tmux source-file ~/.config/tmux/tmux.conf

# Source only the onedark overlay (useful for testing color changes)
source:
    tmux source "{{justfile_directory()}}/onedark.conf"

# Show all @thm_* variables currently set in tmux
show-colors:
    tmux show-options -g | grep '@thm_'
