#!/bin/bash

ram=(
  padding_right=7
  padding_left=7
  update_freq=5
	label.width=30
	label=" - "
	label.padding_left=3
  script="$PLUGIN_DIR/ram.sh"
	icon="$RAM"
)

ram_bracket=(
  background.color="$RAM_BACKGROUND"
  background.border_color="$RAM_DEFAULT"
  background.border_width=2
  background.padding_right=5
)

sketchybar  --add item ram right          \
            --set ram "${ram[@]}"

sketchybar --add bracket ram_bracket ram \
           --set ram_bracket "${ram_bracket[@]}"
