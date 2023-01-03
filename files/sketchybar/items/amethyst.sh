#!/usr/bin/env sh

sketchybar --add item amethyst right                                         \
           --set amethyst icon=                                             \
                          background.color=$MAGENTA                          \
                          icon.padding_left=12                               \
                          icon.color=$BLACK                                  \
                          icon.font="JetBrainsMono Nerd Font Mono:Bold:20.0" \
                          click_script="open -a amethyst"
