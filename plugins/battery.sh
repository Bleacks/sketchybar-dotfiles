#!/bin/bash

source "$CONFIG_DIR/icons.sh"
source "$CONFIG_DIR/colors.sh"

BATTERY_INFO="$(pmset -g batt)"
PERCENTAGE=$(echo "$BATTERY_INFO" | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(echo "$BATTERY_INFO" | grep 'AC Power')
REMAINING=$(echo "$BATTERY_INFO" | grep -Eo "[0-9:]+ remaining" | cut -d ' ' -f1)

if [ $PERCENTAGE = "" ]; then
  sketchybar --animate sin 20 --set $NAME label="nil" label.drawing=on
  exit 0
fi

DRAWING=on
COLOR=$WHITE
case ${PERCENTAGE} in
  9[0-9]|100) ICON=$BATTERY_100
  ;;
  [6-8][0-9]) ICON=$BATTERY_75
  ;;
  [3-5][0-9]) ICON=$BATTERY_50
  ;;
  [1-2][0-9]) ICON=$BATTERY_25; COLOR=$ORANGE
  ;;
  *) ICON=$BATTERY_0; COLOR=$RED
esac

if [[ $CHARGING != "" ]]; then
  ICON=$BATTERY_CHARGING
fi

sketchybar --set $NAME drawing=$DRAWING icon="$ICON" icon.color=$COLOR


mouse_clicked() {
  label=$(sketchybar --query $NAME | jq -r ".label.value")
  if [ "$label" = "" ]; then
    sketchybar --animate sin 20 --set $NAME label="$PERCENTAGE" label.drawing=on
  else
    sketchybar --animate sin 20 --set $NAME label="" label.drawing=off
  fi
}

mouse_entered() {
  label_value="$REMAINING"
  if [ "$REMAINING" = "" ]; then
    label_value="?"
  fi
  sketchybar --animate sin 20 --set $NAME label="$label_value"
}

mouse_exited() {
  drawing=$(sketchybar --query $NAME | jq -r ".label.drawing")
  if [ "$drawing" = "on" ]; then
    sketchybar --animate sin 20 --set $NAME label="$PERCENTAGE"
  fi
}

case "$SENDER" in
  "mouse.clicked") mouse_clicked
  ;;
  "mouse.entered") mouse_entered
  ;;
  "mouse.exited") mouse_exited
  ;;
esac
