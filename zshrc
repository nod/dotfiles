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
# vim mode because reasons
set -o vi

