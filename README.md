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
4. If tmux is running, reloads the config automatically

Safe to re-run — skips if already linked.

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

This configuration uses [vim-plug](https://github.com/junegunn/vim-plug) as a plugin manager.

### Install vim-plug

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

### Install plugins

After setup, open Vim and run:

```vim
:PlugInstall
```

This installs all plugins defined in `.vimrc`.

### Markdown Preview

This setup includes [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim) for live preview.

**Requirements:**

```bash
sudo apt install nodejs npm
```

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

- `:PlugInstall` is only required when adding or updating plugins
- Plugins are stored in `~/.vim/plugged/`

## Uninstall

```bash
rm ~/.vimrc
# Restore backup if available
mv ~/.vimrc.bak ~/.vimrc
```
