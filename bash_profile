# my custom bash goodness

# anything local?
if [ -e $HOME/.bashrc ]; then
	source $HOME/.bashrc
fi

# get our personal helpers

LOCALBIN="~/.localbin"
MDBPATH="~/Work/mongodb-osx-x86_64-2.2.0/bin"
export PATH=$LOCALBIN:$MDBPATH:$PATH:$HOME/.bin

# get me some vim cmd line luvin
set -o vi

# api keys, etc
if [ -e ~/.secrets/secrets ]; then
	source ~/.secrets/secrets
fi

export PYTHONSTARTUP=$HOME/.pythonrc.py

# git related shellery
export GIT_PS1_SHOWDIRTYSTATE=1
source ~/.scriptdir/git-completion.bash

# set up the prompt for the right context
# changes hostname to red if root
export PS1='$( if [ $UID != 0 ]; then echo -n "\[\033[01;32m\]" ; else echo -n "\[\033[0;31m\]"; fi )\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[01;31m\]$(typeset -f __git_ps1>/dev/null && __git_ps1 "(%s)")\[\033[00m\]\$ ' # user


alias sr="sudo bash --login "
alias hilite='egrep -e"" --color=auto -e'
alias up='rsync -a --progress --partial'



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

export GREP_COLOR=$COLOR_RED

alias colorslist="set | egrep 'COLOR_\w*'" # Lists all colors
alias l="ls -lrtF"
alias ll="ls -lF"

# pip command line completion is nice too
# which pip >/dev/null 2>&1 && eval "`pip completion --bash`"
# pip bash completion start
_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip
# pip bash completion end



# A bash completion script for Fabric targets
# Author: Michael Dippery <mdippery@gmail.com>

_complete_fabric() {
  COMPREPLY=()
  if [ -e ./fabfile.py ]; then
    local targets=$(grep 'def [a-z].*' ./fabfile.py | sed -e 's/^def //g' -e 's/(.*)://g')
    local cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -W "${targets}" -- ${cur}) )
  fi
}
complete -o bashdefault -o default -F _complete_fabric fab



# set my timezone to central
export TZ=CST6CDT

# #######################################
# OSX related aliases
# #######################################

export APPLESCRIPT_DIR=$HOME/.applescripts

# alias mvim="open -a MacVim"

alias gitx="open -a GitX"

# itunes related aliases
alias np="osascript ${APPLESCRIPT_DIR}/nowplaying.osa"
alias npp="osascript ${APPLESCRIPT_DIR}/nowplaying.osa|pbcopy && pbpaste"
alias nph="osascript ${APPLESCRIPT_DIR}/nphermes.osa|pbcopy && pbpaste"

function sotd() {
	songpath=`osascript ${APPLESCRIPT_DIR}/sotd.osa`
	shortpath=${songpath##*/}
	echo "Be patient... uploading: ${shortpath} " >&2
	tmp33 "${songpath}"
}

# give me a "show info" from teh cmd line
alias i="osascript ${APPLESCRIPT_DIR}/info.osa > /dev/null 2>&1"

# mount disk image
alias crypt_on="hdid -readonly ${dmg_loc} && cd /Volumes/Crypt"
alias crypt_edit="hdid -readwrite ${dmg_loc} && cd /Volumes/Crypt"
alias crypt_off="cd && hdiutil detach /Volumes/Crypt"


# pip bash completion start
_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip
# pip bash completion end


# virtualenv
vw=`which virtualenvwrapper.sh 2>/dev/null`
if [[ -n "$vw" ]] ; then
	export WORKON_HOME=$HOME/Work/virtualenv
	export PIP_RESPECT_VIRTUALENV=true
	export PIP_VIRTUALENV_BASE=$WORKON_HOME
 	source "$vw"
fi

# helpers from troy on working with github pull reqs

function delp {
    # delete git pull request branch
    br=$(git branch | awk '$1=="*" {print $2; exit}')
    if ! echo "$br" | egrep -q '^pull-[0-9]+$'; then
        echo "\"$br\" is not a pull request branch" >&2
        return 1
    fi
    git checkout master
    git branch -D "$br"
}

function gitdir_top {
    w=$(git rev-parse --git-dir)
    if [[ -n $w ]] ; then
        echo "$w/.."
    fi
}

function git_upstream {
    # which remote name represents the current repo's upstream
    # if there's one named "upstream" pick that one, otherwise, default
    # to "origin".
    git remote | fgrep upstream || echo origin
}

function pullr {
    # pullr : run tests against a pull request
    # given a pull request number, merge the pull request with master,
    # and run testcases.  when finished, if all tests pass, optionally
    # remove the pull request branch.
    pullreq=${1?}
    delpull=$2  # any value deletes pull request branch on passed tests
    (cd $(gitdir_top) &&  # git pulls has to be done at the top
        git co master &&  # make sure we're on master
        git pull $(git_upstream) master && # make sure we're up-to-date
        git pulls update &&
        gh fetch-pull $pullreq merge &&
        fab test)
    rc=$?
    if [[ $rc -eq 0 ]] && [[ -n "$delpull" ]] ; then
        delp
        rc=$?
    fi
    return $rc
}


