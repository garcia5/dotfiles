#!/usr/bin/env sh

sketchybar --add item   net right                   \
           --set net    script="$PLUGIN_DIR/net.sh" \
                        update_freq=1               \
                        background.color=$GREEN     \
                        label.color=$BLACK          \
                        icon.color=$BLACK           \
                        label.y_offset=1
