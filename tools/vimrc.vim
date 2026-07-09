call plug#begin()
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug '/usr/local/bin/fzf'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'jremmen/vim-ripgrep'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-vinegar'
Plug 'vim-utils/vim-man'
Plug 'mbbill/undotree'
Plug 'uguu-org/vim-matrix-screensaver'
Plug 'tweekmonster/django-plus.vim'
Plug 'junegunn/vim-emoji'


Plug 'diacus/rc.vim'
Plug 'diacus/vim-settings'
if has('gui_running')
  Plug 'diacus/vim-gvimsettings'
endif
Plug 'diacus/vim-markdown'
Plug 'diacus/vim-development'
Plug 'diacus/vim-spelling'

" colorscheme
Plug 'arcticicestudio/nord-vim'

" Started to use these for Legacy.com
" Plug 'editorconfig/editorconfig-vim'
call plug#end()

let g:netrw_hide=1
let g:netrw_liststyle=2
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'

silent! colorscheme nord
hi! VertSplit guibg=#3B4252

set completefunc=emoji#complete
command! -range -nargs=0 ExpandEmojis
      \ s/:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/g
