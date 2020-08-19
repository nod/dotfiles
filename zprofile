# login profile, exec'd once

# ##############################################
# setup deterministic machine type
case "$(uname -s)" in
    Linux*)     MyMachine=Linux;;
    Darwin*)    MyMachine=Mac;;
    CYGWIN*)    MyMachine=Cygwin;;
    *)          MyMachine="UNKNOWN:${unameOut}"
esac
export MyMachine


# ##############################################
# get our secrets, api keys, etc
if [[ -e $HOME/.secrets/secrets ]]; then
        source $HOME/.secrets/secrets
fi


# ##############################################
# get my shared helpers if they exist
if [[ -d $HOME/.bin ]]; then
	export PATH=$HOME/.bin:$PATH
fi

# ##############################################
# get our personal helpers if they exist
if [[ -d $HOME/.localbin ]]; then
	export PATH=$HOME/.localbin:$PATH
fi


# ##############################################
# macbin?
if [[ $MyMachine == "Mac" && -d $HOME/.macbin ]]; then
	export PATH=$HOME/.macbin:$PATH
fi

