#!/bin/bash


MPD="$(mpc | head -n 2 | tr '\n' ' ' | sed 's/^\(.*\)\( \[.*\)/\1/')"
MPD_STATE="$(mpc | head -n 2 | tr '\n' ' ' | grep -oG '\[.*\]')"

if [ -z "$MPD" ]; then
    echo 
else
    if [ "$MPD_STATE" = "[paused]" ]; then
        echo "[Paused] <fc=#FFFFCC>$MPD</fc>"
    elif [ -z "$MPD_STATE" ]; then
        echo 
    else
        echo "Playing: <fc=#FFFFCC>$MPD</fc>"
    fi
fi
