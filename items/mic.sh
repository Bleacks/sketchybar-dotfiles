#!/bin/bash

source "$CONFIG_DIR/icons.sh"
source "$CONFIG_DIR/colors.sh"

mic=(
  icon="$MIC_ON"
  label="?%"
  icon.padding_left=7
  label.padding_right=5
  label.padding_left=3
)

mic_bracket=(
  background.color="$MIC_DEFAULT_BACKGROUND"
  background.border_color="$MIC_OFF_BORDER"
  background.border_width=2
  # padding_left=3
  # padding_right=3
)

sketchybar  --add item mic right \
            --set mic "${mic[@]}"

sketchybar  --add bracket mic_bracket mic \
            --set mic_bracket "${mic_bracket[@]}"

sketchybar  --set mic script="$CONFIG_DIR/plugins/mic.sh" \
            --subscribe mic mouse.clicked \
            --set mic_bracket script="$CONFIG_DIR/plugins/mic.sh" \
            --subscribe mic_bracket mouse.clicked
