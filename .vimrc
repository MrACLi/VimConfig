" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2016 Mar 25
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

filetype plugin on
" allow backspacing over everything in insert mode
set backspace=indent,eol,start

"if has("vms")
"  set nobackup		" do not keep a backup file, use versions instead
"else
"  set backup		" keep a backup file (restore to previous version)
"  set undofile		" keep an undo file (undo changes after closing)
"endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab
set nu
set cindent
set wildmenu
language time en_US.utf8
let g:solarized_termcolors=256
let g:solarized_termtrans=1
set background=dark
colorscheme solarized

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set nohlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  au BufRead,BufNewFile *.c exec ":call CConfig()"
  func CConfig()
	  map <F2> :w<CR>
	  map <F9> :w<CR>:silent !clear<CR>:w<CR>:!gcc % -o %:r<CR>
	  map <F10> :silent !clear<CR>:silent !gcc --version<CR>:silent !date<CR>:!./%:r<CR>
  endfunc
  autocmd BufRead *.py exec ":call PythonConfig()"
  autocmd BufNewFile *.py exec ":call PythonConfig()" 
  autocmd BufNewFile *.py exec ":call PythonComment()" 
  func ModTime()
	  let save_cursor = getcurpos()[1:]
	  if(search('Mod Time'))
		  call setline('.', "#   Mod Time		:".strftime("%c")."")
	  endif
	  call cursor(save_cursor)
	  unlet save_cursor
  endfunc
  func PythonComment()
	  call setline(1, "#********************************************************")   
	  call setline(2, "#   Copyright (C) ".strftime("%Y")." All rights reserved.")  
	  call setline(3, "#   ")   
	  call setline(4, "#   Filename		:".expand("%:t")."")   
	  call setline(5, "#   Author		:mracli@qq.com")  
	  call setline(6, "#   Mod Time		:".strftime("%c")."")   
	  call setline(7, "#   Create Date		:".strftime("%c")."")   
	  call setline(8, "#   Describe		:None")   
	  call setline(9, "#")  
	  call setline(10, "#*******************************************************/")   
	  call setline(11, " ")
	  call cursor(11, 1)
  endfunc
  func PythonConfig()
	map <F2> :w<CR>:call ModTime()<CR>
 	map <F9> <F2>:silent !clear<CR>:w<CR>:silent !python --version<CR>:silent !date<CR>:!python %<CR>
 	let g:pydiction_location = '~/.vim/bundle/pydiction/complete-dict'
 	let g:pydiction_menu_height = 5
 	set shiftwidth=4
 	set expandtab
 	set autoindent
 	set fileformat=unix
  endfunc
  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langnoremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If unset (default), this may break plugins (but it's backward
  " compatible).
  set langnoremap
endif


" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
packadd matchit
