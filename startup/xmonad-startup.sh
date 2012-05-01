#!/bin/sh
# Script to configure X, start common apps, and start xmonad.
# Author: Vic Fryzel
# http://github.com/vicfryzel/xmonad-config


# Configure PATH so that we can access our scripts below
PATH=$PATH:~/.xmonad/bin

# Configure X
# xsetroot -cursor_name left_ptr &
# setxkbmap -layout fr -model macbook78 &
# xrdb -merge ~/.Xdefaults &

feh --bg-center ~/Images/wallpapers/6.jpg &

# Start a terminal
urxvt &

exec ck-launch-session dbus-launch --sh-syntax --exit-with-session xmonad

