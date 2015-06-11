"Check to see if the filetype was automagically identified by Vim

if exists("did_load_filetypes")
    finish
endif

augroup filetypedetect
au! BufRead,BufNewFile *.m       setfiletype objc
augroup END

augroup markdown
 au! BufRead,BufNewFile *.mkd   setfiletype mkd
augroup END

augroup json
 au! BufRead,BufNewFile *.json   setfiletype json
augroup END

augroup coffee
 au! BufRead,BufNewFile *.coffee   setfiletype coffee
augroup END

