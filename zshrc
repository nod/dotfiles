# put all aliases, functions, options, etc here.  sourced prior to zlogin

alias wthr='curl "https://wttr.in/~${MYCITY}?un1"'

# make a directory and cd into it because lazy
function mkcd {
	newdir=$1
	mkdir -p $newdir
	cd $newdir
}


