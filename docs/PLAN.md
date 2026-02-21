# Plan: Create catppuccin-onedark-tmux — OneDark flavor for catppuccin/tmux

## Context
The current tmux-onedark-theme fork is a fragile 97-line bash script with embedded Unicode powerline characters, no modularity, and hard-to-maintain single-line format strings. Catppuccin/tmux provides a modern, modular architecture with 15 status modules, 5 separator styles, and a flavor system that lets you swap color palettes via a single variable. Instead of maintaining our own theme from scratch, we create an OneDark color overlay that plugs into catppuccin's framework.

**Key insight**: Catppuccin's format strings use `#{@thm_*}` tmux format expansions (evaluated at runtime). A plugin that loads AFTER catppuccin and overrides these variables will change all colors without forking catppuccin itself.

## Architecture

### How it works
```
tmux.conf load order:
1. catppuccin/tmux loads → sets @thm_* to mocha colors, builds format strings with #{@thm_*}
2. catppuccin-onedark-tmux loads → overrides @thm_* with OneDark colors
3. tmux draws status bar → evaluates #{@thm_*} → uses OneDark colors
```

### Repo structure
```
catppuccin-onedark-tmux/
├── catppuccin-onedark.tmux    # Entry point (bash, sources the conf)
├── onedark.conf               # @thm_* color overrides (tmux conf syntax)
├── CLAUDE.md                  # Dev documentation
├── README.md                  # User documentation
├── LICENSE                    # MIT
└── docs/
    └── PLAN.md                # This plan
```

## Color Mapping

OneDark → catppuccin `@thm_*` variables:

### Base tones (dark → light)
| catppuccin var | hex | derived from |
|----------------|-----|-------------|
| @thm_crust | #1b1f27 | darker than base |
| @thm_mantle | #21252b | Atom One Dark bg-alt |
| @thm_base | #282c34 | onedark_black |
| @thm_surface_0 | #31353f | interpolated |
| @thm_surface_1 | #3e4452 | onedark_visual_grey |
| @thm_surface_2 | #4b5263 | Atom One Dark gutter |
| @thm_overlay_0 | #5c6370 | onedark_comment_grey |
| @thm_overlay_1 | #636d83 | interpolated |
| @thm_overlay_2 | #828997 | interpolated |
| @thm_subtext_0 | #9da5b4 | Atom One Dark fg-alt |
| @thm_subtext_1 | #abb2bf | onedark_white |
| @thm_fg | #abb2bf | onedark_white |

### Accent colors
| catppuccin var | hex | derived from |
|----------------|-----|-------------|
| @thm_rosewater | #e8b0ab | lightened red |
| @thm_flamingo | #e06c75 | onedark_red (alias) |
| @thm_pink | #c678dd | OneDark purple |
| @thm_mauve | #c678dd | OneDark purple |
| @thm_red | #e06c75 | onedark_red |
| @thm_maroon | #be5046 | OneDark dark red |
| @thm_peach | #d19a66 | onedark_dark_yellow |
| @thm_yellow | #e5c07b | onedark_yellow |
| @thm_green | #98c379 | onedark_green |
| @thm_teal | #56b6c2 | OneDark cyan |
| @thm_sky | #56b6c2 | OneDark cyan |
| @thm_sapphire | #519fdf | slightly darker blue |
| @thm_blue | #61afef | onedark_blue |
| @thm_lavender | #7c8dbd | muted blue-grey |

## Files to Create

### 1. `catppuccin-onedark.tmux` (entry point)
```bash
#!/usr/bin/env bash
PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
tmux source "${PLUGIN_DIR}/onedark.conf"
```

### 2. `onedark.conf` (color overrides)
All `set -g @thm_<name> "#rrggbb"` lines from the color mapping table above. Pure tmux config syntax — no bash, no Unicode issues.

### 3. `README.md`
- What it is (OneDark colors for catppuccin/tmux)
- Prerequisites (catppuccin/tmux installed)
- Installation (manual or TPM)
- Screenshot comparison
- Color palette table

### 4. `CLAUDE.md`
- Architecture explanation (color overlay, not a fork)
- Color derivation rationale
- How to add/change colors
- How to test

## Changes to `~/.config/tmux/tmux.conf`

```bash
# Replace current theme setup:
# OLD:
#   set -g @plugin 'colangelo/tmux-onedark-theme'
#   set -g @onedark_widgets "#{prefix_highlight} #(uptime)"
#   set -g @plugin 'tmux-plugins/tmux-prefix-highlight'

# NEW:
# 1. Catppuccin base framework
run ~/.config/tmux/plugins/catppuccin/catppuccin.tmux

# 2. OneDark color overlay (must be after catppuccin)
run ~/.config/tmux/plugins/catppuccin-onedark-tmux/catppuccin-onedark.tmux

# 3. Configure catppuccin modules
set -g @catppuccin_window_status_style "slanted"  # or "rounded" or "custom"
set -g @catppuccin_status_background "#{@thm_base}"
set -g status-left "#{E:@catppuccin_status_session}"
set -g status-right "#{E:@catppuccin_status_date_time}"
set -agF status-right "#{E:@catppuccin_status_uptime}"
set -agF status-right "#{E:@catppuccin_status_host}"
```

## Implementation Steps

### Phase 1: Repo + Plan
1. Create GitHub repo `colangelo/catppuccin-onedark-tmux`
2. Save this plan as `docs/PLAN.md`
3. Create `CLAUDE.md`
4. Commit

### Phase 2: Color Theme
1. Create `onedark.conf` with all @thm_* mappings
2. Create `catppuccin-onedark.tmux` entry point
3. Test: install catppuccin/tmux, load our overlay, verify colors render
4. Commit

### Phase 3: tmux.conf Migration
1. Install catppuccin/tmux (manual clone)
2. Clone our plugin next to it
3. Update tmux.conf: replace old theme with catppuccin + overlay + module config
4. Configure status modules (session, date_time, host, uptime)
5. Test all states (normal, prefix, copy mode)
6. Commit

### Phase 4: Polish
1. Add README with screenshots
2. Fine-tune colors if needed (compare side by side)
3. Push to GitHub
4. Remove old onedark-theme from tmux.conf (keep fork repo as archive)

## Verification
1. `tmux source-file ~/.config/tmux/tmux.conf` — no errors
2. Visual: all segments use OneDark colors, not catppuccin mocha
3. Separators: powerline or rounded arrows render correctly
4. Modules: session name, date/time, hostname, uptime all visible
5. Prefix key: indicator shows when pressed
6. Copy mode: indicator shows in copy mode
7. Compare screenshot with old theme — colors should match
