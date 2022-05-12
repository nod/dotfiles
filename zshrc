
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

# interactive setup

# load custom executable functions
for function in ~/.zsh/functions/*; do
  source $function
done

_load_settings "$HOME/.zsh/configs"

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases


# ################################################
# autocomplete
autoload -Uz compinit; compinit; _comp_options+=(globdots;


# ################################################
# vim mode because reasons
set -o vi

