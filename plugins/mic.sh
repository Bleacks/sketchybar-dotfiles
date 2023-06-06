#!/bin/bash

source "$CONFIG_DIR/icons.sh"
source "$CONFIG_DIR/colors.sh"

MIC_VOLUME=$(osascript -e 'input volume of (get volume settings)')

refresh_status() {
  MIC_VOLUME=$(osascript -e 'input volume of (get volume settings)')

  if [ "$MIC_VOLUME" -eq 0 ]
  then
    ICON="$MIC_OFF"
    BORDER_COLOR="$MIC_OFF_BORDER"
  else
    ICON="$MIC_ON"
    BORDER_COLOR="$MIC_ON_BORDER"
  fi

  sketchybar  --set mic icon="$ICON" \
              --animate sin 20 --set mic label="${MIC_VOLUME}%" \
              --set mic_bracket background.border_color="$BORDER_COLOR"
}

mouse_clicked() {
  if [ "$MIC_VOLUME" -eq 0 ]
  then
    osascript -e 'set volume input volume 100'

  else
    osascript -e 'set volume input volume 0'
  fi
  refresh_status
}

case "$SENDER" in
  "mouse.clicked") mouse_clicked
  ;;
  "routine") refresh_status
  ;;
  "forced") refresh_status
  ;;
esac