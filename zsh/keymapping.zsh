# Disable ctrl-s ctrl-q (suspend, resume. frequently really really annoying!)
# http://geekanova.blogspot.co.uk/2012/11/ctrl-s-freezes-terminal.html
stty -ixon -ixoff

# Fix delete, home and end which would otherwise just caps a random bunch of
# characters. Thanks to Michael Francis for this fix!
# (Amazingly these bindings vary, so this may not work for you. inputrc is
# supposed to be the source for this sort of thing)
source =(
    cat /etc/inputrc |
        sed -ne '/^#/d'        \
            -e 's/://'         \
            -e 's/^/bindkey /' \
            -e '/\(delete-char\|beginning-of-line\|end-of-line\)/p'
)

# This allows the entire line to be used as a search when pressing up or down.
# Move to the start of the line to prevent this.
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# This allows control-r to be used to perform a reverse search
bindkey '^R' history-incremental-search-backward

bindkey '^S' push-line

# This allows alt-. to insert the last word of the last command (i.e. !$)
bindkey "^[." insert-last-word

# Enter command mode and v will provide a full $EDITOR for commands
# N.B. The builtin fc (fix command) can be used to edit and rerun history
autoload -U         edit-command-line
zle      -N         edit-command-line
bindkey  -M vicmd v edit-command-line

# Map control-p to the vim FZF command. Will open vim and run :FZF.
function vim-fzf () {
    if [ $#BUFFER -ne 0 ]
    then
        zle push-line
    fi
    BUFFER='vim +:FZF'
    zle accept-line
}
zle -N                vim-fzf
bindkey -M viins '^P' vim-fzf

function shell-fg () {
    if [ $#BUFFER -ne 0 ]
    then
        zle push-line
    fi
    BUFFER="fg"
    zle accept-line
}
zle -N       shell-fg
bindkey '^Z' shell-fg

function shell-exit () {
    BUFFER="exit"
    zle accept-line
}
zle -N       shell-exit
bindkey '^D' shell-exit

# Prevent ESC eating the next character when in vim normal mode.
# See: http://superuser.com/a/516524
noop () { }
zle -N noop
bindkey -M vicmd '\e' noop

# vim: set ai et sw=4 syntax=zsh :
