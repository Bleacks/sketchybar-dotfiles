#!/bin/bash

# Trigger the brew_udpate event when brew update or upgrade is run from cmdline
# e.g. via function in .zshrc

brew=(
  icon="$PACKAGE"
  script="$PLUGIN_DIR/brew.sh"
  padding_right=7
  padding_left=7
  label=" - "
  label.drawing=on
  label.padding_left=3
  update_freq=3600
  updates=on
)

brew_bracket=(
  background.color="$VOLUME_BACKGROUND"
  background.border_color="$VOLUME_BORDER"
  background.border_width=2
  background.padding_right=5
)

sketchybar --add event brew_update \
           --add item brew right   \
           --set brew "${brew[@]}" \
           --subscribe brew brew_update mouse.clicked

sketchybar --add bracket brew_bracket brew \
           --set brew_bracket "${brew_bracket[@]}"