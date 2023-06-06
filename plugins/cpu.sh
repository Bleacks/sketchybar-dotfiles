#!/bin/bash

source "$CONFIG_DIR/icons.sh"
source "$CONFIG_DIR/colors.sh"

refresh_status() {
  
  CPU_USAGE=$(top -l 2 | grep -E "^CPU" | tail -1 | awk '{ print int($3 + $5 + 0.5)}')

  case $CPU_USAGE in
    [8-9][0-9]|100) CPU_COLOR=$CPU_CRITICAL
    ;;
    [5-7][0-9]) CPU_COLOR=$CPU_HIGH
    ;;
    [2-4][0-9]) CPU_COLOR=$CPU_MEDIUM
    ;;
    [1][0-9]) CPU_COLOR=$CPU_LOW
    ;;
    [0-9]) CPU_COLOR=$CPU_IDLE
    ;;
    *) CPU_COLOR=$CPU_DEFAULT
  esac

  sketchybar  --animate sin 20 --set cpu label="${CPU_USAGE}%" \
              --set cpu_bracket background.border_color="$CPU_COLOR"
}

case "$SENDER" in
  "routine") refresh_status
  ;;
  "forced") refresh_status
  ;;
esac