#!/usr/bin/env bash
#ram.sh
source "$CONFIG_DIR/colors.sh"
memory_usage=$(memory_pressure | grep "System-wide memory free percentage:" | awk '{ printf("%02.0f\n", 100-$5"%") }')

case $memory_usage in
    [7-9][0-9]|100) COLOR=$RED
    ;;
    [5-6][0-9]) COLOR=$ORANGE
    ;;
    [3-4][0-9]) COLOR=$YELLOW
    ;;
    [1-2][0-9]) COLOR=$GREEN
    ;;
    [1-9]) COLOR=$GREEN
    ;;
    *) COLOR=$GRAY
  esac


sketchybar -m --set "$NAME" label="${memory_usage}%" label.color="$COLOR"