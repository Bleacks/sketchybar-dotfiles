#!/bin/bash

source "$CONFIG_DIR/icons.sh"
source "$CONFIG_DIR/colors.sh"

BATTERY_INFO="$(pmset -g batt)"
PERCENTAGE=$(echo "$BATTERY_INFO" | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(echo "$BATTERY_INFO" | grep 'AC Power')
REMAINING=$(echo "$BATTERY_INFO" | grep -Eo "[0-9:]+ remaining" | cut -d ' ' -f1)

refresh() {
  if [ $PERCENTAGE = "" ]; then
    sketchybar --animate sin 20 --set $NAME label=" - "
    exit 0
  fi

  case ${PERCENTAGE} in
    9[0-9]|100) ICON=$BATTERY_100; COLOR=$BATTERY_BORDER_100
    ;;
    [6-8][0-9]) ICON=$BATTERY_75; COLOR=$BATTERY_BORDER_75
    ;;
    [3-5][0-9]) ICON=$BATTERY_50; COLOR=$BATTERY_BORDER_50
    ;;
    [1-2][0-9]) ICON=$BATTERY_25; COLOR=$BATTERY_BORDER_25
    ;;
    *) ICON=$BATTERY_0; COLOR=$BATTERY_BORDER_0
  esac

  if [[ $CHARGING != "" ]]; then
    ICON=$BATTERY_CHARGING
  fi

  sketchybar  --set $NAME icon="$ICON" \
              --set battery_bracket background.border_color="$COLOR"
}

mouse_clicked() {
  LABEL=$(sketchybar --query $NAME | jq -r ".label.value")
  if [[ "$LABEL" == *% ]]
  then
    sketchybar --animate sin 20 --set $NAME label="$REMAINING"
  elif [[ "$LABEL" == *:* ]]
  then
    sketchybar --animate sin 20 --set $NAME label=""
  else
    sketchybar --animate sin 20 --set $NAME label="${PERCENTAGE}%"
  fi
  refresh
}

case "$SENDER" in
  "mouse.clicked") mouse_clicked
  ;;
  *) refresh
  ;;
esac
