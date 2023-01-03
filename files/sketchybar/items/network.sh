#!/usr/bin/env sh

sketchybar  --add item      network right                   \
            --set network   label.padding_right=4           \
                            label.color=$GREEN              \
                            icon=                          \
                            icon.color=$GREEN               \
                            label.padding_right=10          \
                            update_freq=1                   \
                            script="$PLUGIN_DIR/network.sh"
