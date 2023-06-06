#!/bin/bash

battery=(
  script="$PLUGIN_DIR/battery.sh"
  icon.font="$FONT:Regular:19.0"
  padding_right=7
  padding_left=7
  label=" - "
  label.drawing=on
  label.padding_left=3
  icon="$BATTERY_100"
  update_freq=120
  updates=on
)

battery_bracket=(
  background.color="$BATTERY_BACKGROUND"
  background.border_color="$BATTERY_BORDER_100"
  background.border_width=2
  background.padding_right=5
)

sketchybar --add item battery right      \
           --set battery "${battery[@]}" \
           --subscribe battery power_source_change system_woke mouse.clicked
           
sketchybar --add bracket battery_bracket battery \
           --set battery_bracket "${battery_bracket[@]}"