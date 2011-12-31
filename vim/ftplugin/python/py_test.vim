" py_test.vim
" v0.1 27 Aug 2011
" modified from run_python_tests
" See README in ftplugin/python/run_python_tests

" Make sure we run only once
if exists("loaded_py_test")
    finish
endif
let loaded_py_test = 1

" The dir in which this script's dependencies live
let s:rootdir = fnamemodify(expand("<sfile>"), ":h")."/py_test/"

" load python utility functions
" The 'execute' and 'fn*' functions make this more robust under various
" environments than simply using 'pyfile <filename>' would be.
execute "pyfile ".fnameescape(s:rootdir."py_test.py")


"-------------------------------------------------------------------------
" toggle quickfix window open / closed

let s:quickfix_open = 0

function s:ToggleQuickfix()
    if s:quickfix_open == 0
        botright copen
        let s:quickfix_open = 1
    else
        cclose
        let s:quickfix_open = 0
    endif
endfunction

nnoremap <silent> <leader>q :call <SID>ToggleQuickfix()<cr>


"-------------------------------------------------------------------------
" Toggle between a file and its unit test
" The second binding creates the test (or product) file if it doesn't exist.
"nnoremap <silent> <Leader>a :python toggle_test()<cr>
"nnoremap <silent> <Leader>A :python toggle_test(create=True)<cr>


"-------------------------------------------------------------------------
" Asynchronously run the given command 'internally', i.e. capturing output in
" the Vim quickfix window when done

" read the given file into the quickfix window
function! ReadFileIntoQuickfix(temp_file_name)
    " popualate quickfix withgout interrupting user
    exec 'cgetfile '.a:temp_file_name
    call delete(a:temp_file_name)

    call JumpToError()
    " open the quickfix window
"    botright copen
"    let s:quickfix_open = 1

    " don't interrupt whatever user was doing
"    wincmd p

    " clear the command area
"    echo
"    redraw
endfunction


function RunCommandInternal(command)
    " clear the quickfix
    cgete ""

    let temp_file = tempname()

    execute 'silent !'.a:command.' 2>&1 '.
        \ '| python "'.s:rootdir.'filtercwd.py" | tee '.temp_file
    call ReadFileIntoQuickfix(temp_file)
endfunction

function! JumpToError()
    let no_error = 1
    for error in getqflist()
        if error['valid']
            let no_error = 0
            silent cc!
            let error_message = substitute(error['text'], '^\W*', '', 'g')
            call RedBar(error_message)
            "call RedBar("Fail. See QuickFix buffer for errors")
            break
        endif
    endfor
    if no_error
        call GreenBar("All tests passed")
    endif
endfunction

function! RedBar(msg)
    echo
    redraw!
    hi RedBar ctermfg=white ctermbg=red guibg=red
    echohl RedBar
    echom a:msg . repeat(" ",&columns - len(a:msg) - 2)
    echohl
endfunction

function! GreenBar(msg)
    echo
    redraw!
    hi GreenBar ctermfg=white ctermbg=green guibg=green
    echohl GreenBar
    echon a:msg . repeat(" ",&columns - len(a:msg) - 2)
    echohl
endfunction

"-------------------------------------------------------------------------
" Asynchronously run the given command 'externally', i.e. in an external
" cmd window, using 'rerun' (http://bitbucket.org/tartley/rerun)

"function! RunCommandExternal(command)
"    let command = 'python "'.s:rootdir.'rerun.py" '.a:command
"    execute 'silent !'.command.''
"endfunction


"-------------------------------------------------------------------------
" Asynchronously run the given command, and uses thereof

" run the given command
function! RunCommand(command, external)
    echo a:command
    if a:external == 1
        call RunCommandExternal(a:command)
    else
        call RunCommandInternal(a:command)
    endif
endfunction

" run the given python file
function! RunPythonFile(filename, external)
    let s:command = 'python '.expand(a:filename)
    compiler pyunit
    call RunCommand(s:command, a:external)
endfunction

" run the current buffer's Python file
function! RunCurrentPythonFile(external)
"    silent wall
    call RunPythonFile("%", a:external)
endfunction

"nnoremap <silent> <leader>q :call RunCurrentPythonFile(0)<cr>
"nnoremap <silent> <leader>w :call RunCurrentPythonFile(1)<cr>

"-------------------------------------------------------------------------
" Run the unittests of the file in the current buffer
nnoremap <silent> <leader>f :python run_python_tests(external=0)<cr>

"-------------------------------------------------------------------------
" Run the single test method under the text cursor
nnoremap <silent> <leader>t :python run_single_test_method(external=0)<cr>
