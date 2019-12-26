
" An example for a vimrc file.
"
" To use it, copy it to
"     for Unix:     $HOME/.config/nvim/init.vim
"     for Windows:  %LOCALAPPDATA%\nvim\init.vim

set backup             " keep a backup file (restore to previous version)
set undofile           " keep an undo file (undo changes after closing)
set ruler              " show the cursor position all the time
set showcmd            " display incomplete commands



" Don't use Ex mode, use Q for formatting
noremap Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Switch syntax highlighting on
syntax on


set incsearch
set ignorecase
set smartcase
set hlsearch

" Keyboard shortcuts








" Removes stupid status line (lachlan - 21/4/17)
set laststatus=2
hi StatusLine ctermbg=15 ctermfg=8
hi StatusLineNC ctermbg=7 ctermfg=10

nmap <C-L><C-L> :set invrelativenumber<CR>
colorscheme default

" Highlights line cursor is on
"set cursorline
"hi CursorLine cterm=none ctermbg=10

" Organizes swap files in ~/.config/nvim/temp/ (lachlan - 21/4/17)
set directory^=$HOME/.config/nvim/temp//

" Enables line numbers (lachlan - 21/4/17)
set number

" Disables line wrapping (lachlan - 21/4/17)
set nowrap

" Apparently adds support for Vim Addons (ARCH WIKI: lachlan - 21/4/17
set rtp^=/usr/share/vim/vimfile/




"set omnifunc=syntaxcomplete#Complete

"filetype plugin indent on 

"autocmd FileType java setlocal omnifunc=javacomplete#Complete



"    let g:deoplete#enable_at_startup = 1
 "   let g:deoplete#enable_ignore_case = 1
  "  let g:deoplete#enable_smart_case = 1
"    let g:deoplete#enable_refresh_always = 1
"    let g:deoplete#omni#input_patterns = get(g:,'deoplete#omni#input_patterns',{})
"    let g:deoplete#omni#input_patterns.java = [
"        \'[^. \t0-9]\.\w*',
"        \'[^. \t0-9]\->\w*',
"        \'[^. \t0-9]\::\w*',
"        \]
"    let g:deoplete#omni#input_patterns.jsp = ['[^. \t0-9]\.\w*']
"    let g:deoplete#ignore_sources = {}
   " let g:deoplete#ignore_sources._ = ['javacomplete2']
"    inoremap <expr><C-h> deoplete#mappings#smart_close_popup()."\<C-h>"
"    inoremap <expr><BS> deoplete#mappings#smart_close_popup()."\<C-h>"





" Also switch on highlighting the last used search pattern.
set hlsearch

" I like highlighting strings inside C comments.
let c_comment_strings=1

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'textwidth' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  autocmd!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   execute "normal! g`\"" |
    \ endif

augroup END

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis
                 \ | wincmd p | diffthis
endif


"call plug#begin('~/.local/share/nvim/plugged')
"Plug 'Shougo/deoplete.nvim', { 'do': 'UpdateRemotePlugins' }
"Plug 'zchee/deoplete-jedi'
"Plug 'zchee/deoplete-clang'

"Plug 'artur-shaik/vim-javacomplete2'
"Plug 'vim-scripts/vimwiki'
"Plug 'dylanaraps/wal.vim'

"call plug#end()

"g:deoplete#sources#jedi#show_docstring


set completeopt-=preview
set shiftwidth=4
set expandtab
set tabstop=4
colorscheme ron
set cursorline

