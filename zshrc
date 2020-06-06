# interactive setup

# ################################################

source ~/.scriptdir/shell_funcs

export ZSH_THEME_GIT_PROMPT_CACHE=1
source ~/.scriptdir/zsh-git/zshrc.sh

export PROMPT='%F{blue}%m:%f%F{green}%1~%b$(git_super_status)%F{blue}$%f '

# ################################################
# vim mode because reasons
set -o vi
