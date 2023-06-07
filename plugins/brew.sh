#!/bin/bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

refresh() {

  COUNT=$(brew outdated | wc -l | tr -d ' ')
  COLOR=$RED

  case "$COUNT" in
    [3-5][0-9]) COLOR=$ORANGE
    ;;
    [1-2][0-9]) COLOR=$YELLOW
    ;;
    [1-9]) COLOR=$GREEN
    ;;
    0) COLOR=$BRACKET_DEFAULT_BORDER
      COUNT="$CHECK_MARK"
    ;;
  esac

  sketchybar  --set "$NAME" label="$COUNT" \
              --set "${NAME}_bracket" background.border_color="$COLOR"
}

case "$SENDER" in
  "mouse.clicked") refresh
  ;;
  "forced") refresh
  ;;
  "routine") refresh
  ;;
  "brew_update") refresh
  ;;
esac
