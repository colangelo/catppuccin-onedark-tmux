# catppuccin-onedark-tmux

## Architecture

This is a **color pre-load**, not a fork of catppuccin/tmux. It must load **BEFORE** catppuccin.tmux. Catppuccin's flavor files use `set -ogq` (the `-o` flag means "don't overwrite existing values"), so our `set -g` values persist. Catppuccin then uses `-gF` to bake these colors into format strings at load time.

Load order in tmux.conf:
1. `catppuccin-onedark-tmux` loads → sets `@thm_*` with OneDark colors (`set -g`)
2. `catppuccin/tmux` loads → flavor file tries `set -ogq @thm_*` but `-o` preserves our values; `-gF` lines bake OneDark colors into format strings
3. tmux renders status bar → uses OneDark colors everywhere

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
