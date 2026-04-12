#!/bin/bash
set -e

# スクリプトの場所を基準にディレクトリを特定
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Setting up vimrc..."

# 既にこのリポジトリへのシンボリックリンクなら何もしない
if [ -L "$HOME/.vimrc" ] && [ "$(readlink "$HOME/.vimrc")" = "$SCRIPT_DIR/.vimrc" ]; then
    echo "Already linked. Nothing to do."
    exit 0
fi

# 既存の .vimrc をバックアップ（シンボリックリンクでない実ファイルの場合のみ）
if [ -f "$HOME/.vimrc" ] && [ ! -L "$HOME/.vimrc" ]; then
    echo "Backing up existing .vimrc to .vimrc.bak"
    mv "$HOME/.vimrc" "$HOME/.vimrc.bak"
fi

# 古いシンボリックリンクがあれば削除
if [ -L "$HOME/.vimrc" ]; then
    rm "$HOME/.vimrc"
fi

# シンボリックリンク作成
ln -s "$SCRIPT_DIR/.vimrc" "$HOME/.vimrc"

echo "Linked: $HOME/.vimrc -> $SCRIPT_DIR/.vimrc"

# カラースキーム(molokai)のインストール
mkdir -p "$HOME/.vim/colors"
cp "$SCRIPT_DIR/colors/molokai.vim" "$HOME/.vim/colors/molokai.vim"

echo "Installed: molokai.vim -> $HOME/.vim/colors/molokai.vim"
echo "Done."
