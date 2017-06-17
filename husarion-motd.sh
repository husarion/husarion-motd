if [ -n "$SSH_TTY" -a "$SSH_INITIAL_SESSION" = "" ]; then
    export SSH_INITIAL_SESSION=y
    husarion-motd >&2
fi
