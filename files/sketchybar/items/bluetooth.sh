#!/usr/bin/env sh

sketchybar  -m --add event bluetooth_change "com.apple.bluetooth.status" \
            --add item bluetooth right                                   \
            --set bluetooth script="$PLUGIN_DIR/bluetooth.sh"            \
                           update_freq=5                                 \
                           icon.color=$BLUE                              \
            --subscribe bluetooth bluetooth_change
