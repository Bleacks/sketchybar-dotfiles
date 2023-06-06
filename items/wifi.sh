#!/bin/bash

wifi=(
  padding_right=7
  padding_left=7
  update_freq=20
	label=" - "
  icon="$WIFI_ON"
	label.padding_left=3
  icon.padding_right=0
  script="$PLUGIN_DIR/wifi.sh"
)

wifi_bracket=(
  background.color="$WIFI_BACKGROUND"
  background.border_color="$WIFI_DEFAULT"
  background.border_width=2
  background.padding_right=5
)


sketchybar  --add item wifi right           \
            --set wifi "${wifi[@]}"         \
            --subscribe wifi mouse.clicked

sketchybar --add bracket wifi_bracket wifi \
           --set wifi_bracket "${wifi_bracket[@]}"
