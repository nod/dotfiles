
# Enabling and setting git info var to be used in prompt config.
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
# This line obtains information from the vcs.
# zstyle ':vcs_info:git*' formats "(%b)"
zstyle ':vcs_info:git*' formats "(%{$reset_color%}%r/%S%{$fg[grey]%} %{$fg[blue]%}%b%{$reset_color%}%m%u%c%{$reset_color%}) "

precmd() {
    vcs_info
}

# Enable substitution in the prompt.
setopt prompt_subst

# prompt='%2/ ${vcs_info_msg_0_}> '

prompt='%{$fg_bold[green]%}%n@%m:%{$fg_bold[blue]%}%c%{$reset_color%}${vcs_info_msg_0_} %# '
