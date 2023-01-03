#!/usr/bin/env sh

sketchybar  --add item      network right                   \
            --set network   label.padding_right=4           \
                            background.color=$GREEN              \
                            label.color=$BLACK \
                            icon.color=$BLACK \
                            icon=                          \
                            label.padding_right=10          \
                            update_freq=1                   \
                            script="$PLUGIN_DIR/network.sh"
