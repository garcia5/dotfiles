#!/usr/bin/env sh

source "$HOME/.config/sketchybar/icons.sh"
source "$HOME/.config/sketchybar/colors.sh"

airport=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I)
AIRPORT=$(echo "$airport" | awk 'NR==1 {print $2}')
LABEL=$(echo "$airport" | grep -o "SSID: .*" | sed 's/^SSID: //')

if [ $AIRPORT = "Off" ]; then
    sketchybar -m --set net icon=$WIFI_OFF              \
                            icon.color=$RED \
                            label.padding_right=2

elif [ -z "$LABEL" ]; then
    sketchybar -m --set net icon=$WIFI_DISCONNECTED     \
                            icon.color=$RED \
                            label.padding_right=2
else
    sketchybar -m --set net icon=$WIFI_CONNECTED        \
                            label.padding_right=4
fi

sketchybar -m --set net label="$LABEL"
