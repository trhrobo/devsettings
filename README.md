# devsettings

A repository for managing Vim and tmux configuration files with Git.

By creating symlinks from `~/.vimrc` and `~/.tmux.conf` to the files in this repository, Vim and tmux reference the configs directly from here. All changes are made within this repository and tracked by Git.

## Setup

```bash
git clone git@github.com:trhrobo/devsettings.git
cd devsettings
chmod +x setup.sh
./setup.sh
```

`setup.sh` does the following:

1. If `~/.vimrc` / `~/.tmux.conf` exist as regular files, backs them up to `*.bak`
2. Creates symlinks: `~/.vimrc` -> `.vimrc` and `~/.tmux.conf` -> `.tmux.conf` in this repository
3. Installs the molokai color scheme into `~/.vim/colors/`
4. Installs [vim-plug](https://github.com/junegunn/vim-plug) into `~/.vim/autoload/plug.vim`
5. If Neovim is present, creates `~/.config/nvim/init.vim` that sources `~/.vimrc` and installs vim-plug into `~/.local/share/nvim/site/autoload/plug.vim`
6. Installs `nodejs` / `npm` automatically (required by markdown-preview.nvim) via `apt` / `dnf` / `pacman` / `brew` — prompts for sudo password when needed
7. Runs `:PlugInstall!` headlessly for Vim and Neovim, which also builds markdown-preview.nvim
8. If tmux is running, reloads the config automatically

Safe to re-run — already-installed steps are skipped.

## .vimrc Overview

| Category | Details |
|---|---|
| Encoding | UTF-8 (fallback: iso-2022-jp, euc-jp, sjis) |
| Indent | 2 spaces (expandtab) |
| Search | Incremental, smart case |
| Display | Line numbers, cursor line/column highlight, visible whitespace |
| Color scheme | molokai (dark) |

## .tmux.conf Overview

| Category | Details |
|---|---|
| Key mode | vi |
| Clipboard | `set-clipboard on` (OSC 52 passthrough to outer terminal) |
| Copy-mode `v` | Begin selection |
| Copy-mode `y` | Copy selection and cancel (yanks to tmux buffer + emits OSC 52) |

Note: OSC 52 clipboard integration requires the outer terminal emulator to support it (e.g., WezTerm, Alacritty, Kitty, iTerm2). GNOME Terminal does not support OSC 52, so yank will only populate the tmux buffer — use mouse selection for the system clipboard in that case.

## Plugins

This configuration uses [vim-plug](https://github.com/junegunn/vim-plug) as a plugin manager. `setup.sh` installs vim-plug and runs `:PlugInstall!` automatically — no manual steps required.

### Markdown Preview

This setup includes [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim) for live preview. `setup.sh` installs `nodejs` / `npm` and builds the plugin automatically.

**Usage:**

Open a markdown file and run:

```vim
:MarkdownPreview
```

Stop preview:

```vim
:MarkdownPreviewStop
```

### Notes

- Re-run `./setup.sh` after editing plugin definitions in `.vimrc` to install new plugins
- Plugins are stored in `~/.vim/plugged/` (Vim) and `~/.local/share/nvim/plugged/` (Neovim)

## Neovim

If `vim` on your system is actually Neovim (common on Ubuntu where `/usr/bin/vim` is redirected via `update-alternatives`), `setup.sh` handles it automatically by creating `~/.config/nvim/init.vim` that sources `~/.vimrc` and adds `~/.vim` to Neovim's `runtimepath`.

## Uninstall

```bash
rm ~/.vimrc
# Restore backup if available
mv ~/.vimrc.bak ~/.vimrc
```
