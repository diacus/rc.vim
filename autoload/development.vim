" ===========================================================================
" FILE        : autoload/development.vim
" DESCRIPTION : Helper functions for plugin/development.vim
" AUTHOR      : @diacus (diacus.magnuz@gmail.com)
" LAST CHANGE : Mon May 17 09:26:33 CDT 2021
" CREATION    : Thu Jun  7 11:15:14 CDT 2018
" VERSION     : 2.1
" ===========================================================================

let g:code_filetypes = [
      \'c',
      \'cpp',
      \'css',
      \'go',
      \'haskell',
      \'html',
      \'java',
      \'javascript',
      \'javascriptreact',
      \'json',
      \'lua',
      \'matlab',
      \'perl',
      \'php',
      \'python',
      \'rust',
      \'scala',
      \'sh',
      \'sql',
      \'typescript',
      \'vim',
      \'xml',
      \'yaml',
      \'zsh',
      \]

function! development#setup()
  if exists('b:did_development_setup') || index(g:code_filetypes, &ft) == -1
    return
  endif

  let code_width = exists('b:code_width')? b:code_width : 80
  let code_indent = exists('b:code_indent')? b:code_indent : 2
  let code_margin = code_width + 1

  " Format
  for option in ['textwidth', 'tabstop', 'shiftwidth', 'softtabstop']
    exe 'setlocal ' . option . '=' . code_indent
  endfor

  execute 'setlocal textwidth=' . code_width
  execute 'match ErrorMsg /\%>'. code_margin .'v.\+/'

  setlocal formatoptions=croqj
  setlocal expandtab " No tabs in your source code :)

  setlocal numberwidth=6
  " Show line numbers
  if v:version >= 703
    setlocal relativenumber
  endif
  setlocal number

  " Where is the cursor?
  setlocal cursorcolumn
  setlocal cursorline

  let b:did_development_setup = 1
endfunction

function! development#date()
  normal 0f:ld$
  read !date
  normal kJ$
endfunction

function! development#update_tags()
  if filereadable('tags')
    execute 'silent !ctags -R --exclude=.venv --exclude=node_modules . &'
    redraw!
  endif
endfunction

function! development#make_tags()
  if exists('b:did_development_setup')
    execute 'silent !ctags -R --exclude=.venv --exclude=node_modules . &'
    redraw!
  endif
endfunction
