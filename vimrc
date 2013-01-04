set nomodeline " do. not. want.
set nocompatible " old vi is old.

set vb " shhhh

set sw=4 sts=4 ts=4
:au BufEnter *.js set sw=2 sts=2 ts=2 et
:au BufEnter *.md set sw=2 sts=2 ts=2 et
:au BufEnter *.rb set sw=2 ts=2 et ai
:au BufEnter *.yml set sw=2 ts=2 et ai
:au BufEnter *.haml set sw=2 ts=2 et ai
:au BufEnter *.html   set sw=2 sts=2 ts=2 et noai
:au BufEnter *.java set sw=2 sts=2 et ai
:au BufEnter *.py set sw=4 sts=4 et ai
:au BufEnter *.js set sw=2 sts=2 et ai

:syntax on

:let mapleader = ","

if has("gui_running")

" ----------------  GUI ------------------------
set background=light
set guioptions=egmrt
:color solarized

filetype plugin indent on

set colorcolumn=81
set showcmd
" --------------- end GUI -----------------

else
	:color zellner
endif

augroup mkd
  autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
augroup END


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
vmap <silent> <leader>s1 :<C-U>call Swap()<CR>
" Use \S\+ (WORD) as pivot. e.g.: &&
vmap <silent> <leader>ss :<C-U>call Swap('\S')<CR>
" Use \w\+ as pivot.
vmap <silent> <leader>sw :<C-U>call Swap('\w')<CR>


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

" nmap <C-t> :tabnew<cr>
" imap <C-t> <ESC>:tabnew<cr>

set tags+=./tags

" trailing whitespace kills puppies
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" cscope goodness
" set tags=~/.vim/tags/snoball.tags,~/.vim/tags/tornado.tags,~/.vim/tags/mogo.tags
" set nocscopeverbose
" cs add ~/.vim/tags/snoball.cscope
" cs add ~/.vim/tags/tornado.cscope
" cs add ~/.vim/tags/mogo.cscope
" cs add ~/.vim/tags/python.cscope
" set cscopeverbose
