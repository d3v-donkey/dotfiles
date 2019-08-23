#!/bin/bash

# Lister les ecrans => xrandr --prop

xrandr --output HDMI-0 --mode 1920x1080_60


# Positionne le second ecran sur la droite
xrandr --output DVI-0 --pos 1920x0 --mode 1920x1080 --rate 60


