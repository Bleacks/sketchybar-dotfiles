#!/bin/bash

cpu=(
  padding_right=7
  padding_left=7
  update_freq=5
	label.width=30
  label=" - "
	label.padding_left=3
  script="$PLUGIN_DIR/cpu.sh"
  icon="$CPU"
)

cpu_bracket=(
  background.color="$CPU_BACKGROUND"
  background.border_color="$CPU_DEFAULT"
  background.border_width=2
  background.padding_right=5
)

sketchybar  --add item cpu right          \
            --set cpu "${cpu[@]}"

sketchybar  --add bracket cpu_bracket cpu \
            --set cpu_bracket "${cpu_bracket[@]}"