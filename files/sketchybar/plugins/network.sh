#!/usr/bin/env sh

source "$HOME/.config/sketchybar/icons.sh"
source "$HOME/.config/sketchybar/colors.sh"

airport=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I)
AIRPORT=$(echo "$airport" | awk 'NR==1 {print $2}')
LABEL=$(echo "$airport" | grep -o "SSID: .*" | sed 's/^SSID: //')
UPDOWN=$(ifstat -i "en0" -b 0.1 1 | tail -n1)
DOWN_SPEED=$(echo $UPDOWN | awk "{ print \$1 }" | cut -f1 -d ".")
UP_SPEED=$(echo $UPDOWN | awk "{ print \$2 }" | cut -f1 -d ".")
DOWN_SPEED=$(($DOWN_SPEED/8))
UP_SPEED=$(($UP_SPEED/8))
SPEED=""

if [ $AIRPORT = "Off" ] || [ -z "$LABEL" ]; then
    sketchybar -m --set network icon.drawing=off
elif [ "$UP_SPEED" -gt "$DOWN_SPEED" ]; then
    sketchybar -m --set network icon.drawing=on icon=$UPLOAD
    if [ "$UP_SPEED" -gt "999" ]; then
        SPEED=$(echo $UP_SPEED | awk '{ printf "%.1f MB/s", $1 / 1000}')
    else
        SPEED=$(echo $UP_SPEED | awk '{ printf "%.1f KB/s", $1}')
    fi
else
    sketchybar -m --set network icon.drawing=on icon=$DOWNLOAD
    if [ "$DOWN_SPEED" -gt "999" ]; then
        SPEED=$(echo $DOWN_SPEED | awk '{ printf "%.1f MB/s", $1 / 1000}')
    else
        SPEED=$(echo $DOWN_SPEED | awk '{ printf "%.1f KB/s", $1}')
    fi
fi
sketchybar -m --set network label="$SPEED"
