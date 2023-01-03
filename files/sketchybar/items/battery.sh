#!/usr/bin/env sh

sketchybar --add item battery right                      \
           --set battery script="$PLUGIN_DIR/battery.sh" \
                         update_freq=10                  \
                         background.color=$YELLOW        \
                         label.color=$BLACK              \
                         icon.color=$BLACK               \
           --subscribe battery system_woke
