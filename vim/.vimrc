function! DoSomethingIfNoArgs()
    if argc() == 0
        :e ~/.buffer.md
    endif
endfunction

autocmd VimEnter * call DoSomethingIfNoArgs()
nnoremap <SPACE> <Nop>
let mapleader = " "
" Show line numbers + other mine
set number
set relativenumber
set mouse=a
set cmdheight=1
set lazyredraw
set regexpengine=0
set ai "Auto indent
set si "Smart indent
map 0 ^
" set guicursor=n-v-c:block,i:ver25
map Y y$
map <C-c> "*y
nnoremap <leader>c :call system("wl-copy", @")<CR>
map <leader><tab> :bNext<CR>
map <leader>x :bdelete<CR>
map <leader>t :terminal<CR>
map <leader>E :e .<CR>
map <leader>e :Ex<CR>
map <leader>b :enew<CR>
map <leader>k {w0
map <leader>j }b0
set autoread
nmap <leader>w :w!<cr>
map <C-d> <C-d>zz
map <C-u> <C-u>zz
set wildmenu
set showmatch
set lazyredraw
map <leader>z :e ~/.buffer.md<cr>
set mat=2
set novisualbell
set background=dark
:vnoremap < <gv
:vnoremap > >gv
" check spaces at eol
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
:highlight ExtraWhitespace ctermbg=red guibg=red
:match ExtraWhitespace /\s\+$/
map <leader>W :w !sudo tee %<CR>

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>
" Don't try to be vi compatible
" set nocompatible

" Searching
nnoremap / /\v
vnoremap / /\v
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
map <leader><CR> :let @/=''<cr> " clear search

" Helps force plugins to load correctly when it is turned back on below
" filetype off

" TODO: Load plugins here (pathogen or vundle)

" Turn on syntax highlighting
syntax on

" For plugins to load correctly
" filetype plugin indent on

" Security
set modelines=0

" Show file stats
set ruler

" Blink cursor on error instead of beeping (grr)
set visualbell

" Encoding
set encoding=utf-8

" Whitespace
" set wrap
" set textwidth=79
set formatoptions=tcqrn1
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set noshiftround

" Cursor motion
set scrolloff=3
set backspace=indent,eol,start
set matchpairs+=<:> " use % to jump between pairs
runtime! macros/matchit.vim

" Move up/down editor lines
"nnoremap j gj
"nnoremap k gk

" Allow hidden buffers
set hidden

" Rendering
set ttyfast

" Status bar
set laststatus=2

" Last line
set showmode
set showcmd

" Remap help key.
inoremap <F1> <ESC>:set invfullscreen<CR>a
nnoremap <F1> :set invfullscreen<CR>
vnoremap <F1> :set invfullscreen<CR>

" Textmate holdouts

" Formatting
map <leader>q gqip

" Visualize tabs and newlines
set listchars=tab:▸\ ,eol:¬
" Uncomment this to enable by default:
" set list " To enable by default
" Or use your leader key + l to toggle on/off
" map <leader>l :set list!<CR> " Toggle tabs and EOL

" Color scheme (terminal)
set t_Co=256
set background=dark
let g:solarized_termcolors=256
let g:solarized_termtrans=1
" put https://raw.github.com/altercation/vim-colors-solarized/master/colors/solarized.vim
" in ~/.vim/colors/ and uncomment:
" colorscheme solarized
