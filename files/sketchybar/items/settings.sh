#!/usr/bin/env sh

sketchybar --add item settings right                               \
           --set settings icon=                                   \
                          icon.color=$WHITE                        \
                          click_script="open -a 'system settings'"
