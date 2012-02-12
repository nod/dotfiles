set nomodeline " do. not. want.
set nocompatible " old vi is old.

set vb " shhhh

set sw=4 sts=4 ts=4
:au BufEnter *.js set sw=2 sts=2 ts=2 et
:au BufEnter *.rb set sw=2 ts=2 et ai
:au BufEnter *.yml set sw=2 ts=2 et ai
:au BufEnter *.haml set sw=2 ts=2 et ai
:au BufEnter *.html   set sw=2 sts=2 ts=2 et noai
:au BufEnter *.java set sw=4 sts=4 et ai
:au BufEnter *.js set sw=2 sts=2 et ai

:syntax on

if has("gui_running")

" ----------------  GUI ------------------------
set background=dark
set guioptions=egmrt
:color solarized

filetype plugin indent on

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
