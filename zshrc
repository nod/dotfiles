
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

# load funcs
fpath=(~/.zsh/auto $fpath)
autoload -U ~/.zsh/auto/*(:t)

# load custom executable functions
for function in ~/.zsh/functions/*; do
  source $function
done

_load_settings "$HOME/.zsh/configs"

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases

autoload -U colors
colors

setopt PROMPT_SUBST

typeset -ga preexec_functions
typeset -ga precmd_functions
typeset -ga chpwd_functions

preexec_functions+='preexec_update_git_vars'
precmd_functions+='precmd_update_git_vars'
chpwd_functions+='chpwd_update_git_vars'

PROMPT='%{$fg_bold[green]%}%n@%m:%{$fg_bold[blue]%}%c%{$reset_color%}$(prompt_git_info) %# '

# ################################################
# vim mode because reasons
set -o vi

