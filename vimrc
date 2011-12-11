:syntax on

if has("gui_running")

" ----------------  GUI ------------------------
set background=dark
set guioptions=egmrt
:color solarized

filetype plugin on
" --------------- end GUI -----------------

else
	:color zellner
endif

set sw=4 sts=4 ts=4
:au BufEnter *.py set tw=78 ts=4 sw=4 sta et sts=4 ai
:au BufEnter *.js set sw=2 sts=2 ts=2 et
:au BufEnter *.rb set sw=2 ts=2 et ai
:au BufEnter *.yml set sw=2 ts=2 et ai
:au BufEnter *.haml set sw=2 ts=2 et ai
:au BufEnter *.html   set sw=2 sts=2 ts=2 et
:au BufEnter *.java set sw=4 sts=4 et ai
:au BufEnter *.js set sw=2 sts=2 et ai
:au BufEnter *.mkd set ai formatoptions=tcroqn2 comments=n:&gt;

