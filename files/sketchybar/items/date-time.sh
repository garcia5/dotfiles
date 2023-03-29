#!/usr/bin/env sh

sketchybar --add item clock right                      \
           --set clock   update_freq=1                 \
                         script="$PLUGIN_DIR/clock.sh" \
                         background.color=$CYAN        \
                         label.color=$BLACK            \
                         icon.color=$BLACK
