#!/usr/bin/env sh

CURRENT_WIFI="$(/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I | awk -F' SSID: ' '/ SSID: / {print $2}')"
SSID="$(echo "$CURRENT_WIFI" | grep -o "SSID: .*" | sed 's/^SSID: //')"

if [ "$SSID" = "Thida 2" ]; then
  sketchybar --set $NAME label="Disconnected" icon=􀷖
else
  sketchybar --set $NAME label="$SSID" icon=􀷗
fi
