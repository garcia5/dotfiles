#!/usr/bin/env sh

sketchybar -m --add event spotify_change "com.spotify.client.PlaybackStateChanged" \
              --add item spotify "${SKETCHYBAR_SPOTIFY_LOC:-center}"               \
              --set spotify label.color=$GREEN                                     \
                            script="$PLUGIN_DIR/spotify.sh"                        \
                            click_script="open -a spotify"                         \
              --subscribe spotify spotify_change
