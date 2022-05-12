alias wthr="curl 'wttr.in/~cedar+park,tx?un1'"
alias hilite='egrep -e"" --color=auto -e'
alias r='rsync -a --progress --partial'
alias nth='open -a Terminal.app .'
alias colorslist="set | egrep 'COLOR_\w*'" # Lists all colors

export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD

alias ls="ls --color=auto"
alias l="ls -lrtF"
alias ll="ls -lF"
alias scratch="source ~/.scratch/bin/activate"
# OSX related aliases

# itunes related aliases
alias np="osascript ${APPLESCRIPT_DIR}/nowplaying.osa"
alias npp="osascript ${APPLESCRIPT_DIR}/nowplaying.osa|pbcopy && pbpaste"
alias nph="osascript ${APPLESCRIPT_DIR}/nphermes.osa|pbcopy && pbpaste"
alias vmax="osascript ${APPLESCRIPT_DIR}/term_max_height.osa"
alias i="osascript ${APPLESCRIPT_DIR}/info.osa > /dev/null 2>&1"

alias crypt_on="hdid -readonly ${dmg_loc} && cd /Volumes/Crypt"
alias crypt_edit="hdid -readwrite ${dmg_loc} && cd /Volumes/Crypt"
alias crypt_off="cd && hdiutil detach /Volumes/Crypt"

alias brewup='brew update; brew upgrade; brew prune; brew cleanup; brew doctor'
alias fixinkscape='wmctrl -r Inkscape -e 0,2560,1440,1280,800'
alias fixinkscapeExt='wmctrl -r Inkscape -e 0,0,0,1024,1024'
