#!/bin/bash

source "$CONFIG_DIR/plugins/yabai/config.sh"

# $NAME
# $SENDER
# $CONFIG_DIR


mouse_entered() {
  sketchybar --animate sin 10 --set $NAME icon.highlight=on
}

mouse_clicked() {
  PREFIX="${WINDOW_PREFIX}-"
  WINDOW_ID=$(echo ${NAME#"$PREFIX"})
  yabai -m window --focus "$WINDOW_ID"
}

mouse_exited() {
  sketchybar --animate sin 7 --set $NAME icon.highlight=off
}
case "$SENDER" in
  "mouse.entered") mouse_entered
  ;;
  "mouse.clicked") mouse_clicked
  ;;
  "mouse.exited") mouse_exited
  ;;
esac
