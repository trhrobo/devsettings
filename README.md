# vimsettings

A repository for managing Vim configuration files with Git.

By creating a symlink from `~/.vimrc` to the `.vimrc` in this repository, Vim references the config directly from here. All changes are made within this repository and tracked by Git.

## Setup

```bash
git clone git@github.com:trhrobo/vimsettings.git
cd vimsettings
chmod +x setup.sh
./setup.sh
```

`setup.sh` does the following:

1. If `~/.vimrc` exists as a regular file, backs it up to `~/.vimrc.bak`
2. Creates a symlink: `~/.vimrc` -> `.vimrc` in this repository

Safe to re-run — skips if already linked.

## .vimrc Overview

| Category | Details |
|---|---|
| Encoding | UTF-8 (fallback: iso-2022-jp, euc-jp, sjis) |
| Indent | 2 spaces (expandtab) |
| Search | Incremental, smart case |
| Display | Line numbers, cursor line/column highlight, visible whitespace |
| Color scheme | molokai (dark) |

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
