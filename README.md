# My personal terminal setup for Linux, managed with GNU Stow

## What's inside

| Tool                 | Purpose                                        |
| -------------------- | ---------------------------------------------- |
| **Zsh** + Oh My Zsh  | Shell with smart plugins and theming           |
| **Kitty**            | GPU-accelerated terminal emulator              |
| **tmux**             | Terminal multiplexer with vi-style keybindings |
| **Neovim** + LazyVim | Main editor                                    |
| **Yazi**             | Terminal file manager                          |
| **GNU Stow**         | Symlink manager for dotfiles                   |

## Prerequisites

Install everything before symlinking configs.

### 1. Core shell

Zsh is the main shell. Oh My Zsh sits on top of it and manages themes, plugins, and shell helpers.

```bash
# Zsh
sudo apt install zsh

# Set Zsh as the default shell (takes effect on next login)
chsh -s $(which zsh)

# Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### 2. Zsh plugins

These two plugins are loaded in `.zshrc` but are not bundled with Oh My Zsh — they need to be cloned manually into the custom plugins folder:

```bash
# Suggests the most recent matching command as grey text while you type.
# Accept it with the right arrow key.
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Highlights commands in green when they're valid and red when they're not,
# before you even press Enter.
git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

The `git` and `z` plugins are built into Oh My Zsh and need no extra steps.

### 3. Terminal emulator

Kitty is a fast, GPU-rendered terminal. It supports ligatures, images, and splits natively.

```bash
sudo apt install kitty
```

The config uses **JetBrains Mono Nerd Font** at size 13. Nerd Fonts patch regular fonts with thousands of icons used by tools like Neovim, Yazi, and shell prompts. Without it, you'll see broken box characters instead of icons.

```bash
# Quick install via package manager
sudo apt install fonts-jetbrains-mono

# Or download the patched Nerd Font version manually from:
# https://www.nerdfonts.com/font-downloads
# Then place the .ttf files in ~/.local/share/fonts/ and run:
fc-cache -fv
```

### 4. tmux

tmux lets you split a single terminal window into multiple panes, create named windows, and keep sessions alive when you disconnect. `xclip` is a small utility that bridges the tmux clipboard with the system clipboard.

```bash
sudo apt install tmux xclip
```

Without `xclip`, the `Alt+p` paste binding won't work and `y` in copy mode won't write to the system clipboard.

### 5. Neovim

Neovim is the main editor. This config uses [LazyVim](https://lazyvim.org), a pre-configured distribution that sets up LSP, autocompletion, fuzzy finding, and formatting out of the box. LazyVim requires **Neovim 0.9 or later**.

```bash
# Via package manager (may ship an older version — check with `nvim --version`)
sudo apt install neovim

# Or install the latest stable AppImage directly from GitHub
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
chmod +x nvim-linux-x86_64.appimage
sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim
```

On first launch, Lazy.nvim will automatically download and install all plugins. Just wait for it to finish.

**LazyVim extras enabled** (configured in `lazyvim.json`):

- `ai.claudecode` — Claude Code AI assistant integration inside the editor
- `coding.yanky` — keeps a history of everything you've yanked so you can cycle through previous copies
- `editor.fzf` + `editor.telescope` — fuzzy finding for files, grep results, LSP symbols, and more
- `editor.inc-rename` — rename a symbol and see all references update live as you type
- `editor.dial` — increment/decrement numbers, booleans (`true`/`false`), dates, and more with `Ctrl+A`/`Ctrl+X`
- `formatting.black` — auto-format Python with Black on save
- `formatting.prettier` — auto-format JS, TS, HTML, CSS, JSON, Markdown on save
- `linting.eslint` — real-time ESLint diagnostics in JavaScript and TypeScript files
- `lang.*` — full LSP support (completion, go-to-definition, diagnostics) for: Go, Python, TypeScript, SQL, YAML, JSON, TOML, Markdown, Terraform, Ansible, Docker, Tailwind CSS, Git

### 6. Yazi

Yazi is a blazing-fast terminal file manager written in Rust. It shows file previews, supports bulk rename, and integrates with tools like `fzf` and `fd`.

```bash
# Via cargo (recommended — gets the latest version)
cargo install yazi-fm yazi-cli

# Or via package manager
sudo apt install yazi
```

The `keymap.toml` config remaps navigation to `h/j/k/l` so it feels like Vim.

### 7. GNU Stow

Stow is the tool that actually applies your dotfiles. It reads the directory structure inside `~/.dotfiles` and creates matching symlinks in your home directory.

```bash
sudo apt install stow
```

## Installation

```bash
git clone https://github.com/your-username/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Create symlinks for all configs
stow .
```

Stow mirrors the structure of `~/.dotfiles` into `$HOME`. For example, `.config/zsh/.zshrc` in this repo becomes `~/.config/zsh/.zshrc` on your system. If a symlink target already exists, Stow will refuse to overwrite it — back up or remove conflicting files first.

Files listed in `.stow-local-ignore` (`.git`, `*.md`, `*.sh`) are never symlinked.

## Shell configuration

The shell theme is `robbyrussell` — the default Oh My Zsh theme that shows your current directory and git branch status in the prompt.

**Active plugins:**

| Plugin                    | What it does                                                                                                                                 |
| ------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| `git`                     | Adds dozens of short aliases like `gst` for `git status`, `gco` for `git checkout`, and displays branch info in the prompt                   |
| `z`                       | Tracks the directories you visit most. After a few sessions, `z proj` will jump straight to your project folder without typing the full path |
| `zsh-autosuggestions`     | Shows a faint suggestion based on your history as you type — press `→` to accept                                                             |
| `zsh-syntax-highlighting` | Colors your command green if it's valid, red if it's not, before you run it                                                                  |

**Vi mode** is enabled with `bindkey -v`. Press `Esc` at the prompt to enter normal mode, where you can navigate and edit the command line with standard Vim motions (`w`, `b`, `0`, `$`, `cw`, etc.).

**History** is stored at `$XDG_STATE_HOME/zsh/history` with a limit of 100,000 lines. A few options are set to keep it clean:

- `SHARE_HISTORY` — all open shell sessions write to the same history file in real time
- `HIST_IGNORE_DUPS` — consecutive duplicate commands are not saved
- `HIST_IGNORE_SPACE` — commands starting with a space are not saved (useful for secrets)
- `HIST_EXPIRE_DUPS_FIRST` — when the limit is reached, duplicates are removed first

## tmux keybindings

All bindings use `Alt` as the modifier directly — there is no prefix key to press first. This makes navigation much faster.

| Key                | Action                                                       |
| ------------------ | ------------------------------------------------------------ |
| `Alt+n`            | New window                                                   |
| `Alt+L` / `Alt+H`  | Next / previous window                                       |
| `Alt+Q`            | Kill current window                                          |
| `Alt+Enter`        | Split pane horizontally (side by side)                       |
| `Alt+\`            | Split pane vertically (top and bottom)                       |
| `Alt+h/j/k/l`      | Move focus between panes                                     |
| `Ctrl+Alt+h/j/k/l` | Resize the current pane                                      |
| `Alt+f`            | Zoom the current pane to full screen (press again to unzoom) |
| `Alt+q`            | Kill current pane                                            |
| `Alt+[`            | Enter scroll / copy mode                                     |
| `Alt+p`            | Paste from system clipboard                                  |
| `Alt+BSpace`       | Clear the pane's scroll history                              |
| `Alt+R`            | Reload tmux config without restarting                        |

Inside copy mode, `v` starts a visual selection and `y` copies it to the system clipboard via `xclip`. `Escape` cancels.

## Directory structure

```
~/.dotfiles/
├── .bash_aliases        # Extra aliases sourced by .bashrc (e.g. logout shortcut)
├── .bashrc              # Standard Bash config kept as a fallback shell
├── .vimrc               # Minimal Vim config: line numbers, relative numbers, system clipboard
├── .stow-local-ignore   # Tells Stow which files to skip when symlinking
└── .config/
    ├── zsh/
    │   ├── .zshenv      # Loaded for every shell (login, non-login, scripts). Sets XDG paths, EDITOR, and PATH
    │   └── .zshrc       # Interactive shell config: Oh My Zsh, plugins, history, vi mode
    ├── kitty/
    │   └── kitty.conf   # Font family, font size, audio bell disabled
    ├── tmux/
    │   └── tmux.conf    # All keybindings, pane/border styles, clipboard integration
    ├── nvim/            # Neovim config (LazyVim-based)
    │   ├── init.lua     # Entry point — loads LazyVim and sets system clipboard
    │   └── lazyvim.json # Which LazyVim extras are enabled
    └── yazi/
        └── keymap.toml  # Remaps arrow keys to hjkl for Vim-style navigation
```

## XDG base directories

The setup follows the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/latest/), which tells applications where to store their files instead of scattering everything in `$HOME`.

| Variable          | Path             | What goes here                                                                                                                        |
| ----------------- | ---------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| `XDG_CONFIG_HOME` | `~/.config`      | Application configuration files (what you'd normally find as `~/.apprc` dotfiles)                                                     |
| `XDG_CACHE_HOME`  | `~/.cache`       | Non-essential cached data that can be safely deleted (compiled files, thumbnails, plugin indexes)                                     |
| `XDG_DATA_HOME`   | `~/.local/share` | Persistent application data that isn't config (installed fonts, shell completions, application databases)                             |
| `XDG_STATE_HOME`  | `~/.local/state` | State that should persist between sessions but isn't important enough to back up (shell history, undo history, recently opened files) |

Setting these explicitly in `.zshenv` ensures that every tool which respects XDG — including Zsh, Neovim, and others — places its files in predictable, organized locations rather than cluttering your home directory.
