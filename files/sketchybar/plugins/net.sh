#!/usr/bin/env sh

source "$HOME/.config/sketchybar/icons.sh"
source "$HOME/.config/sketchybar/colors.sh"

wdutil="$(sudo wdutil info)"
STATUS=$(echo "$wdutil" | grep -m 1 'Power' | sed -rn 's/.*\[(.+)\].*/\1/p')
LABEL=$(echo "$wdutil" | grep -E '\bSSID\s+:' | cut -d':' -f2 | xargs) # HACKY

if [ "${STATUS}" = "Off" ]; then
    sketchybar -m --set net icon=$WIFI_OFF        \
                            icon.color=$RED       \
                            label.padding_right=2

elif [ -z "${LABEL}" ]; then
    sketchybar -m --set net icon=$WIFI_DISCONNECTED \
                            icon.color=$RED         \
                            label.padding_right=2
else
    sketchybar -m --set net icon=$WIFI_CONNECTED  \
                            icon.color=$BLACK     \
                            label.padding_right=2
fi

sketchybar -m --set net label="$LABEL"
