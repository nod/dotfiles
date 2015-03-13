set nocompatible " old vi is old.
set nomodeline " do. not. want.
set hidden "hide buffers, don't close them

set notitle
" set nowrap        " don't wrap lines
set tabstop=4     " a tab is four spaces
set backspace=indent,eol,start
                  " allow backspacing over everything in insert mode
set autoindent    " always set autoindenting on
set copyindent    " copy the previous indentation on autoindenting
" set number        " always show line numbers
set shiftwidth=4  " number of spaces to use for autoindenting
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch     " set show matching parenthesis
set ignorecase    " ignore case when searching
set smartcase     " ignore case if search pattern is all lowercase,
                  "    case-sensitive otherwise
set smarttab      " insert tabs on the start of a line according to
                  "    shiftwidth, not tabstop
set hlsearch      " highlight search terms
set incsearch     " show search matches as you type
set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set visualbell           " don't beep
set noerrorbells         " don't beep
filetype plugin indent on

:syntax on

:let mapleader=","

set sw=2 sts=2 ts=2

if has('autocmd') " newschool

	autocmd filetype javascript set sw=2 sts=2 ts=2 et
	autocmd filetype json set sw=2 sts=2 ts=2 et
	autocmd filetype ruby set sw=2 ts=2 et ai
	autocmd filetype yaml set sw=2 ts=2 et ai
	autocmd filetype html set sw=2 sts=2 ts=2 et noai
	autocmd filetype java set sw=2 sts=2 et ai
	autocmd filetype python set sw=4 sts=4 et ai
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

endif

if has("gui_running")

let macvim_skip_colorscheme = 1

" ----------------  GUI ------------------------
" set background=dark
set guioptions=egmrt
	:color nodmanian_blood
set colorcolumn=81
set showcmd
set guifont=Source\ Code\ Pro:h12

" --------------- end GUI -----------------

else

"---- cli ---
	:color zenburn
	":color zellner
"---- /cli ---

endif

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>
nmap <silent> cp "_cw<C-R>"<Esc>

map  :r !pbpaste <ENTER>




function! SuperCleverTab()
  if pumvisible()
    return "\<C-N>"
  endif
    if strpart(getline('.'), 0, col('.') - 1) =~ '^\s*$'
        return "\<Tab>"
    else
        if &omnifunc != ''
            return "\<C-X>\<C-O>"
        elseif &dictionary != ''
            return "\<C-K>"
        else
            return "\<C-N>"
        endif
    endif
endfunction
" inoremap <Tab> <C-R>=SuperCleverTab()<cr>
nmap <Tab> <C-R>=SuperCleverTab()<cr>

"http://stackoverflow.com/questions/9458076/swap-selection-around-a-pivot

function! Swap(...) "{{{
  let start_v = col("'<")
  let end_v = col("'>")
  let mv = ''
  let isMv = 0
  while !isMv
    let char = s:GetChar()
    if char == '<Esc>'
      return ''
    endif
    let mv .= char
    let isMv = s:IsMovement(mv)
    echon mv."\r"
  endwhile
  if isMv == 2
    return ''
  endif
  exec "normal! ".end_v.'|'.mv
  let lhs = '\%'.start_v.'c\(.\{-}\S\)'
  if !a:0
    let pivot = '\(\s*\%'.(end_v).'c.\s*\)'
  else
    let pivot = '\(\s*'.a:1.'*\%'.(end_v).'c'.a:1.'\+\s*\)'
  endif
  let rhs = '\(.*\%#.\)'
  exec 's/'.lhs.pivot.rhs.'/\3\2\1/'
endfunction "Swap }}}

function! s:GetChar() "{{{
  let char = getchar()
  if type(char) == type(0) && char < 33
    return '<Esc>'
  elseif char
    let char = nr2char(char)
  endif
  return char
endfunction "GetChar }}}

function! s:IsMovement(mv) "{{{
  let ft = a:mv =~ '^\C\d*[fFtT].$'
  let ft_partial = a:mv =~ '^\C\d*\%([fFtT].\?\)\?$'
  let right = a:mv =~ '^\d*[l$|;,]\|g[m$]$'
  let right_partial = a:mv =~ '^\d*\%([l$|;,]\|g[m$]\?\)\?$'
  if !right_partial && !ft_partial
    return 2
  endif
  return ft || right
endfunction "IsMovement2Right }}}

" Use last char as pivot. e.g.: the comma in the given example.
nmap <silent> <leader>s1 :<C-U>call Swap()<CR>
" Use \S\+ (WORD) as pivot. e.g.: &&
nmap <silent> <leader>ss :<C-U>call Swap('\S')<CR>
" Use \w\+ as pivot.
nmap <silent> <leader>sw :<C-U>call Swap('\w')<CR>


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

set tags+=./tags

" trailing whitespace kills puppies
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
