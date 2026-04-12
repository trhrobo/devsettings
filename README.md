# vimsetting

A repository for managing Vim configuration files with Git.

By creating a symlink from `~/.vimrc` to the `.vimrc` in this repository, Vim references the config directly from here. All changes are made within this repository and tracked by Git.

## Setup

```bash
git clone <repository-url>
cd vimsetting
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

## Uninstall

```bash
rm ~/.vimrc
# Restore backup if available
mv ~/.vimrc.bak ~/.vimrc
```
