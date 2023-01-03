#!/usr/bin/env sh

sketchybar --add item battery right                      \
           --set battery script="$PLUGIN_DIR/battery.sh" \
                         update_freq=10                  \
                         icon.color=$YELLOW              \
                         label.color=$YELLOW             \
           --subscribe battery system_woke
