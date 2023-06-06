#!/usr/bin/env sh

source "$CONFIG_DIR/icons.sh"

CURRENT_WIFI="$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I)"
SSID="$(echo "$CURRENT_WIFI" | grep -o "SSID: .*" | sed 's/^SSID: //')"

refresh() {
  if [ "$SSID" = "" ]; then
    sketchybar --set $NAME label="" icon="$WIFI_OFF"
  else
    sketchybar --set $NAME label="$SSID" icon="$WIFI_ON"
  fi
}

mouse_clicked() {
  IS_LABEL_DRAWED=$(sketchybar --query $NAME | jq -r ".label.drawing")

  if [ "$IS_LABEL_DRAWED" = "off" ]
  then
    sketchybar --set "$NAME" label="" label.drawing=on icon.padding_right=0
    sketchybar --animate sin 20 --set "$NAME" label="$SSID"
  else
    sketchybar --animate sin 20 --set "$NAME" label=""
    sleep 1
    sketchybar --set "$NAME" label="$SSID" label.drawing=off icon.padding_right=5
  fi
  refresh
}

case "$SENDER" in
  "mouse.clicked") mouse_clicked
  ;;
  "forced") refresh
  ;;
  "routine") refresh
  ;;
esac