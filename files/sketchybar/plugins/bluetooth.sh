#!/usr/bin/env sh

STATE=$(blueutil -p)

if [ $STATE = 0 ]; then
  sketchybar --set $NAME label="" icon=
else
  sketchybar --set $NAME label="" icon=
fi
