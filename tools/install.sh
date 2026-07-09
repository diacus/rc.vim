#!/bin/sh
# ===========================================================================
# FILE        : rc.vim/tools/install.sh
# DESCRIPTION : Bootstraps a fresh Vim/Neovim install with this configuration.
#               Downloads tools/vimrc.vim to ~/.vimrc and installs
#               junegunn/vim-plug into both Vim and Neovim autoload paths.
# USAGE       : sh tools/install.sh
#               curl -fL https://raw.githubusercontent.com/diacus/rc.vim/master/tools/install.sh | sh
# AUTHOR      : @diacus (diacus.magnuz@gmail.com)
# VERSION     : 1.0
# ===========================================================================

set -eu

RCVIM_BRANCH="${RCVIM_BRANCH:-master}"
RCVIM_RAW="https://raw.githubusercontent.com/diacus/rc.vim/${RCVIM_BRANCH}/tools/vimrc.vim"
PLUG_URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

VIMRC_DEST="$HOME/.vimrc"
VIM_PLUG_DEST="$HOME/.vim/autoload/plug.vim"
NVIM_PLUG_DEST="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"

# Pick a downloader. curl takes precedence; wget is the fallback.
if command -v curl >/dev/null 2>&1; then
    fetch() { curl -fL --create-dirs -o "$1" "$2"; }
elif command -v wget >/dev/null 2>&1; then
    fetch() { wget -q --create-dirs -O "$1" "$2"; }
else
    echo "error: neither curl nor wget found in PATH" >&2
    exit 1
fi

# Preserve any pre-existing ~/.vimrc by renaming it with a timestamp suffix.
if [ -e "$VIMRC_DEST" ]; then
    backup="$VIMRC_DEST.bak.$(date +%Y%m%d%H%M%S)"
    mv "$VIMRC_DEST" "$backup"
    printf 'Backed up existing %s -> %s\n' "$VIMRC_DEST" "$backup"
fi

printf 'Installing %s\n' "$VIMRC_DEST"
fetch "$VIMRC_DEST" "$RCVIM_RAW"

printf 'Installing %s\n' "$VIM_PLUG_DEST"
fetch "$VIM_PLUG_DEST" "$PLUG_URL"

printf 'Installing %s\n' "$NVIM_PLUG_DEST"
fetch "$NVIM_PLUG_DEST" "$PLUG_URL"

cat <<EOF

Done. Next steps:
  1. Open Vim (or Neovim).
  2. Run :PlugInstall to fetch the plugins listed in the vimrc.
  3. Run :PlugUpdate to bring them up to date.

Tip: override the source branch with RCVIM_BRANCH=dev sh tools/install.sh
EOF
