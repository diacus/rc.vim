#!/bin/sh
# ===========================================================================
# FILE        : rc.vim/tools/install.sh
# DESCRIPTION : Bootstraps a fresh Vim/Neovim install with this configuration.
#               Downloads tools/vimrc.vim to ~/.vimrc and installs
#               junegunn/vim-plug into both Vim and Neovim autoload paths.
# USAGE       : sh tools/install.sh
#               curl -fL https://raw.githubusercontent.com/diacus/rc.vim/master/tools/install.sh | sh
#               DRY_RUN=1 sh tools/install.sh        # write into a temp dir, no real changes
# AUTHOR      : @diacus (diacus.magnuz@gmail.com)
# VERSION     : 1.0
# ===========================================================================

set -eu

# Refuse to run with an unset or empty $HOME. Without this guard a user who
# invokes the script via `curl ... | sh` after a typo'd `HOME=` overwrite would
# silently write to the parent shell's real $HOME.
if [ -z "${HOME-}" ]; then
    echo "error: \$HOME is unset or empty; refusing to run." >&2
    echo "       (piped invocations like 'curl ... | sh' cannot be sandboxed" >&2
    echo "        with HOME= on the left side of the pipe; download the script" >&2
    echo "        first and run it directly with the env var in scope.)" >&2
    exit 1
fi

# Optional dry-run mode: redirect every write into a fresh temp directory
# instead of $HOME. Useful for previewing what the script will do without
# touching real config files. Set DEST_ROOT explicitly to override.
if [ -n "${DEST_ROOT:-}" ]; then
    : # caller-supplied; use as-is
elif [ -n "${DRY_RUN:-}" ]; then
    DEST_ROOT="$(mktemp -d -t rc-vim-install.XXXXXX)"
    trap 'rm -rf "$DEST_ROOT"' EXIT INT TERM
    printf 'DRY_RUN=1: writing into temp dir %s\n' "$DEST_ROOT"
else
    DEST_ROOT="$HOME"
fi

RCVIM_BRANCH="${RCVIM_BRANCH:-master}"
RCVIM_RAW="https://raw.githubusercontent.com/diacus/rc.vim/refs/heads/${RCVIM_BRANCH}/tools/vimrc.vim"
PLUG_URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

VIMRC_DEST="$DEST_ROOT/.vimrc"
VIM_PLUG_DEST="$DEST_ROOT/.vim/autoload/plug.vim"
NVIM_PLUG_DEST="$DEST_ROOT/${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"

# Pick a downloader. curl takes precedence; wget is the fallback.
if command -v curl >/dev/null 2>&1; then
    fetch() { curl -fL --create-dirs -o "$1" "$2"; }
elif command -v wget >/dev/null 2>&1; then
    fetch() { wget -q --create-dirs -O "$1" "$2"; }
else
    echo "error: neither curl nor wget found in PATH" >&2
    exit 1
fi

# install_file exits the whole process on failure. We do not rely on
# `set -e` + `return 1` because dash, busybox sh, and bash each have
# their own quirks around when a non-zero return from a function call
# is considered fatal. `exit 1` is unambiguous everywhere.
install_file() {
    dest=$1
    url=$2

    dir=$(dirname "$dest")
    mkdir -p "$dir"

    tmp="$dest.new"
    if ! fetch "$tmp" "$url"; then
        rm -f "$tmp"
        echo "error: failed to download $url" >&2
        exit 1
    fi

    if [ -e "$dest" ]; then
        backup="$dest.bak.$(date +%Y%m%d%H%M%S)"
        mv "$dest" "$backup"
        printf 'Backed up existing %s -> %s\n' "$dest" "$backup"
    fi

    mv "$tmp" "$dest"
    printf 'Installed %s\n' "$dest"
}

install_file "$VIMRC_DEST"    "$RCVIM_RAW"
install_file "$VIM_PLUG_DEST" "$PLUG_URL"
install_file "$NVIM_PLUG_DEST" "$PLUG_URL"

cat <<EOF

Done. Next steps:
  1. Open Vim (or Neovim).
  2. Run :PlugInstall to fetch the plugins listed in the vimrc.
  3. Run :PlugUpdate to bring them up to date.

Tip: override the source branch with RCVIM_BRANCH=dev sh tools/install.sh
Tip: preview changes without touching \$HOME with DRY_RUN=1 sh tools/install.sh
EOF
