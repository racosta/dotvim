if v:progname =~? "evim"
  finish
endif

execute pathogen#infect()
"call pathogen#runtime_append_all_bundles()
"call pathogen#helptags()

" Use Vim settings, rather than Vi settings (much better!)
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set autochdir         " Automatically change to current file's directory
set nobackup          " Don't create vim backup files everywhere
set history=50        " Keep 50 lines of command line history
set ruler             " Show the curson position all the time
set showcmd           " Display incomplete commands
set incsearch         " Do incremental searching
set showmode          " Show VIM mode (Insert, Visual, ...)
set showmatch         " Show matching () {} [] "" '' <>
set tabstop=4         " Use 4 spaces
set shiftwidth=4      " Use 4 spaces
set expandtab         " Use spaces instead of tabs
set equalalways       " Make splits equal size
set encoding=utf8     " Use UTF-8 encoding
set foldenable        " Turn on folding
set foldmethod=syntax " Fold based on file syntax
set foldlevel=100     " Don't autofold anything
set splitright        " Split vertically to open new file on right
set splitbelow        " Split horizontally to open new file below
set laststatus=2      " Display the status line
set wildmenu
set wildmode=list:longest
set cursorline        " Highlight the line the cursor is on
set visualbell
set ttyfast
set modeline
syntax enable

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can do CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on
  set smartindent

  " Put these in an autocmd group, so that we can delete them easily
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
  augroup END
else
  set smartindent " always set autoindenting on
endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
          \ | wincmd p | diffthis
endif

autocmd FileType python set tabstop=4|set shiftwidth=4|set expandtab
autocmd FileType perl   set tabstop=4|set shiftwidth=4|set expandtab
autocmd FileType cpp    set tabstop=4|set shiftwidth=4|set expandtab
autocmd FileType ruby   set tabstop=2|set shiftwidth=2|set expandtab

" Commenting blocks of code.
autocmd FileType c,cpp,java          let b:comment_leader = '// '
autocmd FileType sh,ruby,python,perl let b:comment_leader = '# '
autocmd FileType conf,fstab          let b:comment_leader = '# '
autocmd FileType tcsh,csh            let b:comment_leader = '# '
autocmd FileType tex                 let b:comment_leader = '% '
autocmd FileType mail                let b:comment_leader = '> '
autocmd FileType vim                 let b:commend_leader = '" '
noremap <silent> ,cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> ,cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>

" Add underlining to a title by typing \H on that line
noremap <Leader>H yyp^v$r-o<Esc>

" Move between windows in a split screen
noremap <C-H> <C-w>h
noremap <C-L> <C-w>l
noremap <C-J> <C-w>j
noremap <C-K> <C-w>k

map <Leader>t :TlistToggle<CR><CR>

function! SetExecutableBit()
  let fname = expand("%:p")
  checktime
  execute "au FileChangedShell " . fname . " :echo"
  silent !chmod a+x %
  checktime
  execute "au! FileChangedShell " . fname
endfunction

" automatically give executable permissions file begins with #! and
" contains "/bin" in the path
autocmd BufWritePost *
  \ if getline(1) =~ "^#!" |
  \   if getline(1) =~ "/bin/" |
  \     call SetExecutableBit() |
  \   endif |
  \ endif

" DEFAULT COLORSCHEME: In case I can't get Solarized to work properly
" Set colorscheme, and change the line numbers to be dark grey
colo delek
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

imap jj <Esc>
map <leader>e :e! ~/.vimrc<CR>

map <F2> : call SetDarkSolarized() <CR>
map <F3> : call SetLightSolarized() <CR>
map <F4> :TlistToggle<CR><CR>

func! SetDarkSolarized()
    :set t_Co=256
    :set bg=dark
    :let g:solarized_termtrans=1
    :let g:solarized_termcolors=256
    :let g:solarized_style="dark"
    :let g:solarized_visibility="high"
    :let g:solarized_contrast="high"
    :colo solarized
endfunc

func! SetLightSolarized()
    :set t_Co=256
    :set bg=light
    :let g:solarized_termtrans=0
    :let g:solarized_termcolors=256
    :let g:solarized_style="light"
    :let g:solarized_visibility="high"
    :let g:solarized_contrast="high"
    :colo solarized
endfunc

func! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfunc

" When vimrc is edited, reload it
autocmd! bufwritepost vimrc source ~/.vimrc

: call SetDarkSolarized()

if version >= 702
    au VimResized * wincmd = " Doesn't work for linux version 6.2.98

    autocmd InsertEnter * syn clear EOLWS | syn match EOLWS excludenl /\s\+\%#\@!$/
    autocmd InsertLeave * syn clear EOLWS | syn match EOLWS excludenl /\s\+$/
    highlight EOLWS ctermbg=darkred guibg=darkred

    nmap <silent> <C-D> :NERDTreeToggle<CR>

    let Tlist_Inc_Winwidth      = 0      " Don't change window width
    let Tlist_Auto_Update       = 1      " Automatically add new tags to the list
    let Tlist_Use_Right_Window  = 1      " Open the taglist on the right side
    let Tlist_Exit_OnlyWindow   = 1      " Exit vim if taglist is only open window
    let Tlist_Sort_Type         = "name" " Sort by tag name instead of order
    let Tlist_Display_Tag_Scope = 1

    autocmd FileType c,cpp,java  set colorcolumn=80|set nu|set numberwidth=5
    autocmd FileType python,perl set colorcolumn=80|set nu|set numberwidth=5
    autocmd FileType ruby,tex    set colorcolumn=80|set nu|set numberwidth=5
    autocmd FileType c,cpp,java,python,perl,ruby,tcsh,vim,bash,sh,make,tex autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

    let perl_fold=1
    let g:xml_syntax_folding=1
    au FileType xml setlocal foldmethod=syntax

    let g:lightline = {
        \ 'colorscheme': 'solarized',
        \ }

    let g:airline_powerline_fonts=1
    let g:airline_theme='airlineish'

" Replaced by vim-airline, vim-fugitive, vim-airlineish
" Replaced by lightline
"    hi StatusLine guifg=DarkBlue guibg=White ctermfg=DarkBlue ctermbg=White
"
"    hi StatColor guibg=#95e454 guifg=black ctermbg=darkgreen ctermfg=black
"    hi Modified  guibg=orange  guifg=black ctermbg=darkred   ctermfg=black
"
"    function! MyStatusLine(mode)
"      let statusline=""
"      if a:mode == 'Enter'
"        let statusline.="%#StatColor#"
"      endif
"      let statusline.="\(%n\)\ %f\ "
"      if a:mode == 'Enter'
"        let statusline.="%*"
"      endif
"      let statusline.="%#Modified#%m"
"      if a:mode == 'Leave'
"        let statusline.="%*%r"
"      elseif a:mode == 'Enter'
"        let statusline.="%r%*"
"      endif
"      let statusline.="\ (%l/%L,\ %c)\ %P%=%q%h%w\ %y\ [%{&encoding}:%{&fileformat}]\ \ "
"      return statusline
"    endfunction
"
"    au WinEnter * setlocal statusline=%!MyStatusLine('Enter')
"    au WinLeave * setlocal statusline=%!MyStatusLine('Leave')
"    set statusline=%!MyStatusLine('Enter')
"
"    function! InsertStatusLineColor(mode)
"      if a:mode == 'i'
"        hi StatColor guibg=orange ctermbg=darkred
"      elseif a:mode == 'r'
"        hi StatColor guibg=#e454ba ctermbg=darkmagenta
"      elseif a:mode == 'v'
"        hi StatColor guibg=#e454ba ctermbg=darkmagenta
"      else
"        hi StatColor guibg=red ctermbg=red
"      endif
"    endfunction
"
"    au InsertEnter * call InsertStatusLineColor(v:insertmode)
"    au InsertLeave * hi StatColor guibg=#95e454 guifg=black ctermbg=darkgreen ctermfg=black

" Old
"hi StatColor guibg=#95e454 guifg=black ctermbg=lightgreen ctermfg=black
"hi Modified guibg=orange guifg=black ctermbg=lightred ctermfg=black
"
"function! MyStatusLine(mode)
"    let statusline=""
"    if a:mode == 'Enter'
"        let statusline.="%#StatColor#"
"    endif
"    let statusline.="\(%n\)\ %f\ "
"    if a:mode == 'Enter'
"        let statusline.="%*"
"    endif
"    let statusline.="%#Modified#%m"
"    if a:mode == 'Leave'
"        let statusline.="%*%r"
"    elseif a:mode == 'Enter'
"        let statusline.="%r%*"
"    endif
"    let statusline .= "\ (%l/%L,\ %c)\ %P%=%h%w\ %y\ [%{&encoding}:%{&fileformat}]\ \ "
"    return statusline
"endfunction
"
"au WinEnter * setlocal statusline=%!MyStatusLine('Enter')
"au WinLeave * setlocal statusline=%!MyStatusLine('Leave')
"set statusline=%!MyStatusLine('Enter')
"
"function! InsertStatuslineColor(mode)
"  if a:mode == 'i'
"    hi StatColor guibg=orange ctermbg=lightred
"  elseif a:mode == 'r'
"    hi StatColor guibg=#e454ba ctermbg=magenta
"  elseif a:mode == 'v'
"    hi StatColor guibg=#e454ba ctermbg=magenta
"  else
"    hi StatColor guibg=red ctermbg=red
"  endif
"endfunction
"
"au InsertEnter * call InsertStatuslineColor(v:insertmode)
"au InsertLeave * hi StatColor guibg=#95e454 guifg=black ctermbg=lightgreen ctermfg=black
"au InsertLeave * hi Modified guibg=orange guifg=black ctermbg=lightred ctermfg=black
endif