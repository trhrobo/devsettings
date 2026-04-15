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

# vim-plug を指定パスに取得するヘルパー
fetch_plug_vim() {
    local dest="$1"
    if [ -f "$dest" ]; then
        echo "vim-plug already installed at $dest"
        return
    fi
    echo "Installing vim-plug -> $dest"
    mkdir -p "$(dirname "$dest")"
    if command -v curl >/dev/null 2>&1; then
        curl -fLo "$dest" --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    elif command -v wget >/dev/null 2>&1; then
        wget -O "$dest" \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    else
        echo "Error: curl or wget is required to install vim-plug." >&2
        exit 1
    fi
}

# Vim 用 vim-plug
fetch_plug_vim "$HOME/.vim/autoload/plug.vim"

# Neovim 用のセットアップ（`vim`が実体 nvim の環境を含む）
if command -v nvim >/dev/null 2>&1; then
    # nvim も同じ設定を読むよう init.vim を作成（未存在のときのみ）
    NVIM_CONFIG="$HOME/.config/nvim/init.vim"
    if [ ! -e "$NVIM_CONFIG" ]; then
        mkdir -p "$(dirname "$NVIM_CONFIG")"
        cat > "$NVIM_CONFIG" <<'EOF'
set runtimepath^=~/.vim
set runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
EOF
        echo "Created: $NVIM_CONFIG (sources ~/.vimrc)"
    else
        echo "Nvim config already exists: $NVIM_CONFIG (skipped)"
    fi
    # nvim 用 vim-plug
    fetch_plug_vim "$HOME/.local/share/nvim/site/autoload/plug.vim"
fi

# markdown-preview のビルドに npm が必要なので未導入なら自動インストール
if ! command -v npm >/dev/null 2>&1; then
    echo "npm not found. Installing nodejs and npm..."
    if command -v apt >/dev/null 2>&1; then
        # 他リポジトリのエラーで停止しないよう update 失敗は許容
        sudo apt update || echo "Warning: apt update had errors (continuing)"
        sudo apt install -y nodejs npm
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y nodejs npm
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -S --noconfirm nodejs npm
    elif command -v brew >/dev/null 2>&1; then
        brew install node
    else
        echo "Error: could not detect package manager. Install nodejs/npm manually." >&2
        exit 1
    fi
fi

# プラグインの自動インストール（ヘッドレスで :PlugInstall 実行）
run_plug_install() {
    local bin="$1"
    if command -v "$bin" >/dev/null 2>&1; then
        echo "Running :PlugInstall via $bin..."
        "$bin" --headless -c "PlugInstall! --sync" -c "qa" 2>&1 | tail -5 || true
    fi
}
run_plug_install vim
run_plug_install nvim

# ~/.bashrc の force_color_prompt を有効化（tmux 内でも緑プロンプトを維持）
BASHRC="$HOME/.bashrc"
if [ -f "$BASHRC" ] && grep -q '^#force_color_prompt=yes' "$BASHRC"; then
    sed -i 's/^#force_color_prompt=yes/force_color_prompt=yes/' "$BASHRC"
    echo "Enabled force_color_prompt in $BASHRC"
fi

# tmuxが起動中なら設定を再読み込み
if [ -n "$TMUX" ]; then
    tmux source-file "$HOME/.tmux.conf"
    echo "Reloaded tmux config."
fi

echo "Done."
