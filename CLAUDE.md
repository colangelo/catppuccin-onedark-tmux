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

## How to Customize catppuccin Options in tmux.conf

Catppuccin has three kinds of tmux options — understanding the difference is critical:

1. **`set -ogq` (with `-o`)**: Won't overwrite existing values. Set your override BEFORE `run catppuccin.tmux` and it sticks. Example: `@catppuccin_host_color`, `@catppuccin_host_text`, `@thm_*` palette vars.

2. **`set -gqF` (with `-F`, no `-o`)**: Evaluates format strings and ALWAYS overwrites. These are internal variables built during loading. You cannot pre-set them — they'll be overwritten.

3. **Conditional sets (`%if` guards)**: Some internal vars like `@catppuccin_status_*_icon_bg` are only set if empty. On first load this works, but on **reload** the old value persists and the `%if` is skipped. **Fix: set the internal `_icon_bg` variable directly** in tmux.conf to ensure it's always correct.

### Reload gotcha

On `tmux source-file`, tmux options from the previous load are NOT cleared. Catppuccin's `%if "#{==:#{@var},}"` guards see stale values and skip updates. Always set derived variables (like `@catppuccin_status_*_icon_bg`) explicitly — don't rely on catppuccin computing them from `@catppuccin_*_color`.

### Colors: use hex, not colour names

Catppuccin embeds colors in `#[fg=...,bg=...]` tmux style strings via `-gF`. Use hex values (`"#870000"`) not tmux colour names (`"colour88"`) — hex is what catppuccin expects and is more reliable in format string evaluation.

### Short hostnames

Use `#h` (tmux built-in short hostname) not `#(hostname -s)` (shell command). The `#H` format gives the full hostname including `.local`.

## How to Add/Change OneDark Palette Colors

Edit `onedark.conf`. Each line is `set -g @thm_<name> "#rrggbb"`. The variable names must match catppuccin's expected `@thm_*` names exactly.

## Development

- Always commit granularly — one logical change per commit
- `~/.config/tmux/tmux.conf` is managed by chezmoi — after editing, run `chezmoi add ~/.config/tmux/tmux.conf` and commit in the chezmoi repo (`~/.local/share/chezmoi`)

## How to Test

```bash
tmux source-file ~/.config/tmux/tmux.conf
```

Verify: status bar segments use OneDark colors, not catppuccin mocha defaults.
