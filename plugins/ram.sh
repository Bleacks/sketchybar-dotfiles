#!/bin/bash


source "$CONFIG_DIR/icons.sh"
source "$CONFIG_DIR/colors.sh"

refresh_status() {
  
  RAM_USAGE=$(memory_pressure | grep "System-wide memory free percentage:" | awk '{ printf("%02.0f\n", 100-$5"%") }')

  case $RAM_USAGE in
    [7-9][0-9]|100) COLOR=$RAM_CRITICAL
    ;;
    [5-6][0-9]) COLOR=$RAM_HIGH
    ;;
    [3-4][0-9]) COLOR=$RAM_MEDIUM
    ;;
    [1-2][0-9]) COLOR=$RAM_LOW
    ;;
    [1-9]) COLOR=$RAM_IDLE
    ;;
    *) COLOR=$RAM_DEFAULT
  esac

  sketchybar  --set ram label="${RAM_USAGE}%" \
              --set ram_bracket background.border_color="$COLOR"
}

case "$SENDER" in
  "routine") refresh_status
  ;;
  "forced") refresh_status
  ;;
esac
