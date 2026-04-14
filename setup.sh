#!/bin/bash
set -e

# スクリプトの場所を基準にディレクトリを特定
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# $1 -> リポジトリ内のファイル名 (例: .vimrc)
# $2 -> ホーム直下のリンク先ファイル名 (例: .vimrc)
link_dotfile() {
    local src="$SCRIPT_DIR/$1"
    local dest="$HOME/$2"

    echo "Setting up $2..."

    # 既にこのリポジトリへのシンボリックリンクなら何もしない
    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        echo "Already linked. Nothing to do."
        return
    fi

    # 既存の実ファイルをバックアップ（シンボリックリンクでない場合のみ）
    if [ -f "$dest" ] && [ ! -L "$dest" ]; then
        echo "Backing up existing $2 to $2.bak"
        mv "$dest" "$dest.bak"
    fi

    # 古いシンボリックリンクがあれば削除
    if [ -L "$dest" ]; then
        rm "$dest"
    fi

    ln -s "$src" "$dest"
    echo "Linked: $dest -> $src"
}

link_dotfile ".vimrc" ".vimrc"
link_dotfile ".tmux.conf" ".tmux.conf"

# カラースキーム(molokai)のインストール
mkdir -p "$HOME/.vim/colors"
cp "$SCRIPT_DIR/colors/molokai.vim" "$HOME/.vim/colors/molokai.vim"
echo "Installed: molokai.vim -> $HOME/.vim/colors/molokai.vim"

# tmuxが起動中なら設定を再読み込み
if [ -n "$TMUX" ]; then
    tmux source-file "$HOME/.tmux.conf"
    echo "Reloaded tmux config."
fi

echo "Done."
