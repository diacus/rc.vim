# Personal Run Commands Vim and Configuration

This repo includes my personal collection of settings and custom commands.

## Installation

### Quick install

The fastest way to get a working Vim/Neovim setup with this configuration is
to run the bundled installer. It downloads `tools/vimrc.vim` into
`$HOME/.vimrc` and installs [`junegunn/vim-plug`](https://github.com/junegunn/vim-plug)
into both Vim and Neovim autoload paths.

```
sh tools/install.sh
```

Or, without cloning the repo first:

```
curl -fL https://raw.githubusercontent.com/diacus/rc.vim/master/tools/install.sh | sh
```

Any existing `~/.vimrc` is backed up to `~/.vimrc.bak.<timestamp>` before being
overwritten. After the script finishes, open Vim and run `:PlugInstall` to
fetch the plugins listed in the vimrc, then `:PlugUpdate` to bring them up to
date.

The default branch is `master`; override with
`RCVIM_BRANCH=dev sh tools/install.sh` to install from a different branch.

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
