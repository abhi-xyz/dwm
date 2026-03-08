#!/usr/bin/env bash

feh --bg-scale /home/abhi/.background-image 
picom &
conky --daemonize --pause=1 -c ~/.config/conky/system &
clipcatd &
maestral start &
