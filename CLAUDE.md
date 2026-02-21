# catppuccin-onedark-tmux

## Architecture

This is a **color overlay**, not a fork of catppuccin/tmux. Catppuccin's format strings use `#{@thm_*}` tmux format expansions evaluated at runtime. This plugin loads AFTER catppuccin and overrides those variables with OneDark hex values — all catppuccin modules then render in OneDark colors automatically.

Load order in tmux.conf:
1. `catppuccin/tmux` loads → sets `@thm_*` to mocha palette
2. `catppuccin-onedark-tmux` loads → overrides `@thm_*` with OneDark colors
3. tmux evaluates `#{@thm_*}` → uses OneDark colors

## Files

- `catppuccin-onedark.tmux` — Bash entry point, sources the conf file
- `onedark.conf` — All `@thm_*` color variable overrides (pure tmux syntax)

## Color Derivation

Base tones are derived from Atom One Dark's background palette (bg, bg-alt, gutter, comment-grey, fg, fg-alt). Accent colors map directly from OneDark's 8 syntax colors (red, green, yellow, blue, purple, cyan, dark-yellow, dark-red). Gaps (rosewater, sapphire, lavender) are interpolated/shifted variants to fill catppuccin's larger palette.

## How to Add/Change Colors

Edit `onedark.conf`. Each line is `set -g @thm_<name> "#rrggbb"`. The variable names must match catppuccin's expected `@thm_*` names exactly.

## Development

- Always commit granularly — one logical change per commit

## How to Test

```bash
tmux source-file ~/.config/tmux/tmux.conf
```

Verify: status bar segments use OneDark colors, not catppuccin mocha defaults.
