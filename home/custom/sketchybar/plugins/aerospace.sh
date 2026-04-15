#!/usr/bin/env bash

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME label.color=0xff261c13 \
							background.drawing=on 
else
    sketchybar --set $NAME label.color=0xff7c7b61 \
						    background.drawing=off
fi
