#!/usr/bin/env sh

sketchybar --add item amethyst right                                         \
           --set amethyst icon=                                             \
                          icon.padding_right=-1                               \
                          icon.color=$MAGENTA                                \
                          icon.font="JetBrainsMono Nerd Font Mono:Bold:20.0" \
                          click_script="open -a amethyst"
