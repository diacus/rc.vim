# Personal Run Commands Vim and Configuration

This repo includes my personal collection of settings and custom commands.

## Installation

### Quick install

The fastest way to get a working Vim/Neovim setup with this
configuration is to run the bundled installer. It downloads
`tools/vimrc.vim` into `$HOME/.vimrc` and installs
[`junegunn/vim-plug`](https://github.com/junegunn/vim-plug) into both Vim and Neovim autoload paths.

```
sh tools/install.sh
```

Or, without cloning the repo first:

```
curl -fL https://raw.githubusercontent.com/diacus/rc.vim/refs/heads/master/tools/install.sh -o install.sh \
  && sh install.sh
```

The script is split into a download step and a run step on purpose: a
one-liner like `curl ... | sh` swallows transport failures (a 429 or
404 from `raw.githubusercontent.com` means `sh` runs against an empty
stdin and silently exits 0). The two-step form above makes the
download's exit code visible, so a failure stops the run before any
side effects.

If a `~/.vimrc` already exists it is renamed to `~/.vimrc.bak.<timestamp>`
*after* the new vimrc has been successfully downloaded, so a failed run
leaves your existing configuration untouched. After the script finishes,
open Vim and run `:PlugInstall` to fetch the plugins listed in the vimrc,
then `:PlugUpdate` to bring them up to date.

The default branch is `master`; override with
`RCVIM_BRANCH=dev sh tools/install.sh` to install from a different branch.

To preview what the script will do without touching `$HOME`, run
`DRY_RUN=1 sh tools/install.sh` — every file is written to a temp
directory that is removed on exit. This is the recommended way to test
the installer. (Piped invocations like `curl ... | sh` cannot be
sandboxed with `HOME=` on the left side of the pipe; download the
script first and run it directly with the env var in scope.)

### Manual install

Install it like any other plugin, I recommend using the plugin manager of our
choice. For example `plug.vim` at your `$HOME/.vimrc` add:

```
call plug#begin('~/Projects/rc.vim/plug')
" other plugins...
Plug 'diacus/rc.vim'
" other plugins...
call plug#end()
```

## Getting help

Once installed, you can see the documentation within the vim's help system

```
:help rc.vim
```
