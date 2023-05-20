#!/bin/bash

source "$CONFIG_DIR/plugins/yabai/utility.sh"

#
# Listener functions
#

window_created() {
  if [ "$1" = "" ]
  then
    WINDOW_ID="$YABAI_PROCESS_ID"
  else
    WINDOW_ID="$1"
  fi
  create_window "$WINDOW_ID"
}

window_destroyed() {
  if [ "$1" = "" ]
  then
    WINDOW_ID="$YABAI_PROCESS_ID"
  else
    WINDOW_ID="$1"
  fi
  destroy_window "$WINDOW_ID"
}

space_changed() {
  CURRENT_SPACE_ID="$1"
  RECENT_SPACE_ID="$2"

  refresh_space "$CURRENT_SPACE_ID"
  refresh_space "$RECENT_SPACE_ID"
}

application_launched() {
  echo application_launched
}

application_front_switched() {
  # CURRENT_PROCESS_ID="$1"
  # CURRENT_WINDOW=$(yabai -m query --windows | jq --arg FILTER "$CURRENT_PROCESS_ID" '.[] | select(.pid == ($FILTER | tonumber)) | .id')
  # for WINDOW_ID in $CURRENT_WINDOW
  # do
  #   refresh_window "$WINDOW_ID" &
  # done
  
  RECENT_PROCESS_ID="$2"
  RECENT_WINDOW=$(yabai -m query --windows | jq --arg FILTER "$RECENT_PROCESS_ID" '.[] | select(.pid == ($FILTER | tonumber)) | .id')

  for WINDOW_ID in $RECENT_WINDOW
  do
    refresh_window "$WINDOW_ID"
  done
}

window_focused() {
  WINDOW_ID="$1"

  refresh_window "$WINDOW_ID"
}

case "$SENDER" in
  "application_launched") application_launched
  ;;
  # "application_terminated") application_terminated
  # ;;
  "application_front_switched") application_front_switched "$YABAI_PROCESS_ID" "$YABAI_RECENT_PROCESS_ID"
  ;;
  # "application_activated") application_activated
  # ;;
  # "application_deactivated") application_deactivated
  # ;;
  # "application_visible") application_visible
  # ;;
  # "application_hidden") application_hidden
  # ;;
  "window_created") window_created "$YABAI_WINDOW_ID"
  ;;
  "window_destroyed") window_destroyed "$YABAI_WINDOW_ID"
  ;;
  "window_focused") window_focused "$YABAI_WINDOW_ID"
  ;;
  # "window_moved") window_moved
  # ;;
  # "window_resized") window_resized
  # ;;
  # "window_minimized") window_minimized
  # ;;
  # "window_deminimized") window_deminimized
  # ;;
  # "window_title_changed") window_title_changed
  # ;;
  "space_changed") space_changed "$YABAI_SPACE_ID" "$YABAI_RECENT_SPACE_ID"
  ;;
  # "display_added") display_added
  # ;;
  # "display_removed") display_removed
  # ;;
  # "display_moved") display_moved
  # ;;
  # "display_resized") display_resized
  # ;;
  # "display_changed") display_changed
  # ;;
  # "mouse.clicked") mouse_clicked
  # ;;
  # "forced") exit 0
  # ;;
  # # ;;
  # # "window_focus") refresh_windows
  # "window_hidden") hide_window
  # ;;
  # "windows_on_spaces") update_spaces
  # ;;
  # "front_app_switched") update_front_app
  # ;;
  "*") echo "Wrong event sent to yabai-helper"
  ;;
esac
