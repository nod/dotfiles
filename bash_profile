# my custom bash goodness

# get me some vim cmd line luvin
set -o vi

# api keys, etc
if [ -z ~/.secrets/secrets ]; then
	source ~/.secrets/secrets
fi

export PYTHONSTARTUP=$HOME/.pythonrc.py

# git related shellery
export GIT_PS1_SHOWDIRTYSTATE=1
source ~/.scriptdir/git-completion.bash

# this shows a colorized git repo dirty state
export PS1='\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[01;31m\]$(__git_ps1 "(%s)")\[\033[00m\]\$ '

# Setup some colors to use later in interactive shell or scripts
export COLOR_NONE='\e[0m' # No Color
export COLOR_WHITE='\e[1;37m'
export COLOR_BLACK='\e[0;30m'
export COLOR_BLUE='\e[0;34m'
export COLOR_LIGHT_BLUE='\e[1;34m'
export COLOR_GREEN='\e[0;32m'
export COLOR_LIGHT_GREEN='\e[1;32m'
export COLOR_CYAN='\e[0;36m'
export COLOR_LIGHT_CYAN='\e[1;36m'
export COLOR_RED='\e[0;31m'
export COLOR_LIGHT_RED='\e[1;31m'
export COLOR_PURPLE='\e[0;35m'
export COLOR_LIGHT_PURPLE='\e[1;35m'
export COLOR_BROWN='\e[0;33m'
export COLOR_YELLOW='\e[1;33m'
export COLOR_GRAY='\e[1;30m'
export COLOR_LIGHT_GRAY='\e[0;37m'
export CLICOLOR=1

alias colorslist="set | egrep 'COLOR_\w*'" # Lists all colors
alias ls="ls -F --color"
alias l="ls -lrtF --color"
alias ll="ls -lF --color"


# #######################################
# OSX related aliases
# #######################################

export APPLESCRIPT_DIR=$HOME/.applescripts

alias mvim="open -a MacVim"

# itunes related aliases
alias np="osascript ${APPLESCRIPT_DIR}/nowplaying.osa"
alias npp="osascript ${APPLESCRIPT_DIR}/nowplaying.osa|pbcopy"

# give me a "show info" from teh cmd line
alias i="osascript ${APPLESCRIPT_DIR}/info.osa > /dev/null 2>&1"

# mount disk image
alias crypt_on="hdid -readonly /Volumes/iDisk/Documents/crypt.dmg && cd /Volumes/Crypt"
alias crypt_edit="hdid -readwrite /Volumes/iDisk/Documents/crypt.dmg && cd /Volumes/Crypt"
alias crypt_off="cd && hdiutil detach /Volumes/Crypt"
