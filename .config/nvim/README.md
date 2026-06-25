# Neovim Configuration

Personal neovim configuration built on **Neovim v0.11.6** (built from source) with
**lazy.nvim** as the plugin manager.

## Structure

```
~/.config/nvim/
├── init.lua                  # Entry point: bootstraps lazy.nvim, loads options & plugins
├── lua/
│   ├── vim-options.lua       # Core editor settings (tabs, indentation, diagnostics)
│   ├── text-wrap.lua         # Custom text wrapping module (79 char limit)
│   └── plugins/
│       ├── R-nvim.lua        # R language support (R.nvim) with pipe operator & code blocks
│       ├── colorscheme.lua   # Bamboo colorscheme (moon variant)
│       ├── completion.lua    # Autocompletion (nvim-cmp, LuaSnip, autopairs)
│       ├── eighty-limit.lua  # Subtle vertical line at column 80 (virt-column)
│       ├── iron.lua          # Python REPL integration (iron.nvim with ipython)
│       ├── lazygit.lua       # LazyGit integration (<leader>lg)
│       ├── lsp-config.lua    # LSP setup via Mason (pyright, lua_ls, r_language_server, etc.)
│       ├── lualine.lua       # Status line (dracula theme)
│       ├── mini-move.lua     # Move lines/selections with Alt+h/j/k/l
│       ├── neo-tree.lua      # File tree explorer (<C-n>)
│       ├── oil.lua           # Floating file manager (-)
│       ├── telescope.lua     # Fuzzy finder (<C-p> files, <leader>fg live grep)
│       ├── transparency.lua  # Transparent background
│       ├── treesitter.lua    # Syntax highlighting & indentation (master branch)
│       ├── vim-be-good.lua   # Vim practice game
│       └── which-key.lua     # Keybinding hints
└── lazy-lock.json            # Pinned plugin versions
```

## Key Bindings

| Key | Mode | Action |
|-----|------|--------|
| `<Space>` | - | Leader key |
| `<C-p>` | Normal | Find files (Telescope) |
| `<leader>fg` | Normal | Live grep (Telescope) |
| `<C-n>` | Normal | Toggle file tree (Neo-tree) |
| `-` | Normal | Toggle floating file manager (Oil) |
| `<leader>lg` | Normal | Open LazyGit |
| `K` | Normal | Hover documentation (LSP) |
| `gd` | Normal | Go to definition (LSP) |
| `<leader>ca` | Normal/Visual | Code actions (LSP) |
| `<leader>dh` / `<leader>ds` | Normal | Hide/Show diagnostics |
| `<leader>a` | Normal | Wrap paragraph at 79 chars |
| `Alt+h/j/k/l` | Normal/Visual | Move lines/selections |
| `<Esc>` | Terminal | Exit terminal mode |
| `<CR>` / `<Tab>` | Insert | Confirm completion |
| `<C-Space>` | Insert | Trigger completion |

### R-specific (r, rmd, quarto filetypes)

| Key | Mode | Action |
|-----|------|--------|
| `<C-S-m>` | Insert | Insert pipe operator ` \|> ` |
| `<LocalLeader>kc` | Normal | Insert R code block |

### Python REPL (iron.nvim)

| Key | Mode | Action |
|-----|------|--------|
| `<localleader>rf` | Normal | Open Python REPL |
| `<localleader>rq` | Normal | Close REPL |
| `<localleader>rs` | Normal | Restart REPL |
| `<localleader>d` | Normal | Send line to REPL |
| `<localleader>sd` | Visual | Send selection to REPL |
| `<localleader>aa` | Normal | Send entire file to REPL |

## Prerequisites

- **Neovim v0.11.6** (built from source at `~/manualInstalls/neovim`)
- **JetBrainsMono Nerd Font** (installed at `~/.local/share/fonts/JetBrainsMono/`)
  - Set this font in your terminal emulator for icons to display correctly
- **ipython** (optional, for enhanced Python REPL; falls back to python3)
- **lazygit** (for the LazyGit integration)

## Troubleshooting Notes

### Double-enter key press in insert mode

**Problem:** After syncing plugins with `:Lazy sync`, pressing Enter in insert mode
would insert two newlines instead of one.

**Root cause:** The neovim installation was a dev build (`v0.12.0-dev`) which had
compatibility issues with the installed plugin versions. The `nvim-cmp` completion
plugin and `nvim-autopairs` both handled the `<CR>` key, and the dev build caused
them to conflict.

**Fix (applied):**
1. Rebuilt neovim from the latest stable release (`v0.11.6`) instead of the dev branch
2. Cleared plugin data (`~/.local/share/nvim/lazy/`) and cache (`~/.cache/nvim/`)
   to force a clean reinstall of all plugins
3. Updated the `<CR>` mapping in `completion.lua` to only confirm completions when
   the completion menu is visible, falling back to normal behavior otherwise
4. Pinned `nvim-treesitter` to the `master` branch (the `main` branch dropped the
   `nvim-treesitter.configs` API needed by v0.11.x)

### Missing icons/symbols in terminal

**Problem:** Nerd Font icons (used by Neo-tree, Lualine, Oil, etc.) displayed as
blank squares or question marks.

**Fix:** Installed JetBrainsMono Nerd Font and set it as the terminal font.

```bash
# Install the font
mkdir -p ~/.local/share/fonts
cd /tmp
curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip -o JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMono
fc-cache -fv ~/.local/share/fonts
```

Then set "JetBrainsMono Nerd Font" in your terminal emulator's font settings.
