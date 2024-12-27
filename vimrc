set nocompatible " old vi is old.
set nomodeline " do. not. want.
set hidden "hide buffers, don't close them
set nocursorline   " show a line where the cursor is
set textwidth=80
set colorcolumn=+1,120 " highlight the edges of sanity
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
	autocmd filetype go set sw=2 sts=2 et ai
	autocmd filetype golang set sw=2 sts=2 et ai
	autocmd filetype scala set sw=2 sts=2 et ai
	autocmd filetype jade set sw=2 sts=2 et ai
	autocmd filetype coffee set sw=2 sts=2 et ai
	autocmd filetype swift set sw=4 sts=4 et ai
	autocmd filetype markdown set sw=2 sts=2 ts=2 et
	autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
else " oldschool
	:au BufEnter *.md set sw=2 sts=2 ts=2 et
	:au BufEnter *.rb set sw=2 ts=2 et ai
	:au BufEnter *.yml set sw=2 ts=2 et ai
	:au BufEnter *.scala set sw=2 ts=2 et ai
	:au BufEnter *.html   set sw=2 sts=2 ts=2 et noai
	:au BufEnter *.js set sw=2 sts=2 ts=2 et
	:au BufEnter *.json set sw=2 sts=2 ts=2 et
	:au BufEnter *.java set sw=2 sts=2 et ai
	:au BufEnter *.yaml set sw=2 ts=2 et ai
	:au BufEnter *.py set sw=4 sts=4 et ai
	:au BufEnter *.jade set sw=2 sts=2 et ai
	:au BufEnter *.coffee set sw=4 sts=4 et ai
	:au BufEnter *.go set sw=2 sts=2 et ai
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

" filetype plugin indent on
syntax enable

" dont let color schemes override bg color of term
hi Normal ctermbg=none
highlight ColorColumn ctermbg=236

" trailing whitespace is bad
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" kill trailing spaces
map <leader>kts :%s/\s\+$//g<ENTER>

"since has('macunix') is buggy and annoying we can do good enough (TM) OS
"detection on the fly with this snippet from


" https://stackoverflow.com/questions/10139972/vim-hasmacunix-or-hasmac-do-not-work
" has('macunix') is buggy
let os=substitute(system('uname'), '\n', '', '')
if os == 'Darwin' || os == 'Mac'
	" copy to clipboard from first line to end of file
	map <leader>xa :w !pbcopy <ENTER>
	" copy to clipboard from current line to end of file
	map <leader>xe 0!Gpbcopy <ENTER>u
	" copy to clipboard current line
	map <leader>xl 0!$pbcopy <ENTER>u
	" copy to clipboard visually selected
	map <leader>xv !pbcopy <ENTER>u
	" paste from clipboard
	" prevents https://thejh.net/misc/website-terminal-copy-paste
	" (see also |quoteplus| and |quotestar| in vim help)
	map \a :r !pbpaste <ENTER>
elseif os == 'Linux'
	" copy to clipboard from first line to end of file
	map <leader>xa :w !xclip -i<ENTER>
	" copy to clipboard from current line to end of file
	map <leader>xe 0!Gxclip -i<ENTER>u
	" copy to clipboard current line
	map <leader>xl 0!$xclip -i <ENTER>u
	" copy to X11 selection from current visual range
	map <leader>xv !xclip -i<ENTER>u
	" copy to clipboard from current visual range
	map <leader>xc !xclip -selection clipboard -i<ENTER>u

	" paste from clipboard
	" prevents https://thejh.net/misc/website-terminal-copy-paste
	" (see also |quoteplus| and |quotestar| in vim help)
	map \a :r !xclip -o<ENTER>
	map \c :r !xclip -selection clipboard -o<ENTER>
endif



" some plugin junk
" don't forget to :PlugInstall after changing these
call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
call plug#end()

" setup airline
set t_Co=256
let g:airline_powerline_fonts=1
let g:airline_theme='molokai' " murmur
let g:airline_section_z="%3p%% %#__accent_bold#%{g:airline_symbols.linenr}%4l%#__restore__#%#__accent_bold#/%L%#__restore__# :%3v"
let g:airline#extensions#branch#enabled=1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"

