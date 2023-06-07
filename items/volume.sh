#!/bin/bash

volume_slider=(
  script="$PLUGIN_DIR/volume.sh"
  updates=on
  label.drawing=off
  icon.drawing=off
  slider.highlight_color=$BLUE
  slider.background.height=5
  slider.background.corner_radius=3
  slider.background.color=$VOLUME_DEFAULT_BACKGROUND
  slider.knob=􀀁
  slider.knob.drawing=off
)

volume_icon=(
  icon=$VOLUME_100
  padding_left=7
  padding_right=7
  label=""
)

volume_bracket=(
  background.color="$VOLUME_BACKGROUND"
  background.border_color="$VOLUME_BORDER"
  background.border_width=2
  background.padding_right=5
)


sketchybar --add slider volume right            \
           --set volume "${volume_slider[@]}"   \
           --subscribe volume volume_change     \
                              mouse.clicked     \
                              mouse.entered     \
                              mouse.exited      \
                                                \
           --add item volume_icon right         \
           --set volume_icon "${volume_icon[@]}"

sketchybar --add bracket volume_bracket volume volume_icon \
           --set volume_bracket "${volume_bracket[@]}"
