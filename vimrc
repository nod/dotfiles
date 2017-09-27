set nocompatible " old vi is old.
set nomodeline " do. not. want.
set hidden "hide buffers, don't close them
set nocursorline   " show a line where the cursor is
set title " show filename in terminal title
set tabstop=4     " a tab is four spaces by default
set shiftwidth=4  " number of spaces to use for autoindenting
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
set smarttab      " insert tabs on the start of a line according to
                  "    shiftwidth, not tabstop
set backspace=indent,eol,start
                  " allow backspacing over everything in insert mode
set autoindent    " always set autoindenting on
set copyindent    " copy the previous indentation on autoindenting
set nonumber      " don't show line numbers
set showmatch     " set show matching parenthesis
set ignorecase    " ignore case when searching
set smartcase     " ignore case if search pattern is all lowercase,
                  "    case-sensitive otherwise
set hlsearch      " highlight search terms
set incsearch     " show search matches as you type
set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set visualbell           " don't beep
set noerrorbells         " don't beep
" set colorcolumn=81 " highlight the edge of sanity
set textwidth=80
set colorcolumn=+1,120 " highlight the edge of sanity

let g:netrw_list_hide= '.*\.swp$,.*\.pyc$'


:let mapleader=","

" some same defaults
set sw=4 sts=4 ts=4

if has('autocmd') " newschool
	autocmd filetype javascript set sw=2 sts=2 ts=2 et
	autocmd filetype json set sw=2 sts=2 ts=2 et
	autocmd filetype ruby set sw=2 ts=2 et ai
	autocmd filetype yaml set sw=2 ts=2 et ai
	autocmd filetype html set sw=2 sts=2 ts=2 et noai
	autocmd filetype java set sw=2 sts=2 et ai
	autocmd filetype python set sw=4 sts=4 et ai
	autocmd filetype jade set sw=2 sts=2 et ai
	autocmd filetype coffee set sw=2 sts=2 et ai
	autocmd filetype swift set sw=4 sts=4 et ai
	autocmd filetype markdown set sw=2 sts=2 ts=2 et
	autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
else " oldschool
	:au BufEnter *.md set sw=2 sts=2 ts=2 et
	:au BufEnter *.rb set sw=2 ts=2 et ai
	:au BufEnter *.yml set sw=2 ts=2 et ai
	:au BufEnter *.html   set sw=2 sts=2 ts=2 et noai
	:au BufEnter *.js set sw=2 sts=2 ts=2 et
	:au BufEnter *.json set sw=2 sts=2 ts=2 et
	:au BufEnter *.java set sw=2 sts=2 et ai
	:au BufEnter *.py set sw=4 sts=4 et ai
	:au BufEnter *.jade set sw=2 sts=2 et ai
	:au BufEnter *.coffee set sw=4 sts=4 et ai
endif


if has("gui_running")
" ----------------  GUI ------------------------
" set background=dark
"
"
"
"


" set guioptions=egmrt
set guioptions=egm
:color gotham
set showcmd
set guifont=Source\ Code\ Pro\ Light:h12
highlight ColorColumn guibg=LightSteelBlue4
" --------------- end GUI -----------------
else
"---- cli ---
" :color jellybeans
:color ub
highlight ColorColumn ctermbg=236
"---- /cli ---
endif

" tab navigation like ffox
nmap <S-tab> :tabprevious<cr>
nmap <C-tab> :tabnext<cr>
map <S-tab> :tabprevious<cr>
map <C-tab> :tabnext<cr>
imap <S-tab> <ESC>:tabprevious<cr>i
imap <C-tab> <ESC>:tabnext<cr>i
map <C-J> <C-W>j<C-W>
map <C-K> <C-W>k<C-W>
map <C-h> <C-W>h<C-W>
map <C-l> <C-W>l<C-W>

nmap <C-j> :%!jq .<cr>

filetype plugin indent on
syntax on

" dont let color schemes override bg color of term
hi Normal ctermbg=none
highlight ColorColumn ctermbg=236

" trailing whitespace kills puppies
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

