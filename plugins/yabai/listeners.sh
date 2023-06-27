#!/bin/bash

source "$CONFIG_DIR/plugins/yabai/utility.sh"

#
# Listener functions
#

get_display_index_from_id() {
  DISPLAY_ID="$1"

  DISPLAY_INDEX=$(yabai -m query --displays --display "$DISPLAY_INDEX" | jq '.index')

  echo "$DISPLAY_INDEX"
}

refresh_display() {
  source "$CONFIG_DIR/plugins/yabai/utility.sh"

  DISPLAY_ID="$1"
  DISPLAY_INDEX=$(get_display_index_from_id "$DISPLAY_INDEX")

  sleep 5

  refresh_spaces_on_display "$DISPLAY_INDEX"

  refresh_bar
}

display_changed() {
  source "$CONFIG_DIR/plugins/yabai/utility.sh"

  RECENT_DISPLAY_ID="$1"
  RECENT_DISPLAY_INDEX=$(get_display_index_from_id "$RECENT_DISPLAY_ID")
  CURRENT_DISPLAY_ID="$2"
  CURRENT_DISPLAY_INDEX=$(get_display_index_from_id "$CURRENT_DISPLAY_ID")

  # TODO: Implement something more efficient
  refresh_spaces_on_display "$RECENT_DISPLAY_INDEX"
  refresh_spaces_on_display "$CURRENT_DISPLAY_INDEX"
  
  # RECENT_SPACE_INDEX=$(yabai -m query --spaces --display "$RECENT_DISPLAY_INDEX" | jq '.[] | select(.["has-focus"]) | .index')
  # CURRENT_SPACE_INDEX=$(yabai -m query --spaces --display "$CURRENT_DISPLAY_INDEX" | jq '.[] | select(.["has-focus"]) | .index')

  # space_changed "$CURRENT_SPACE_INDEX" "$RECENT_SPACE_INDEX"
}

space_changed() {
  source "$CONFIG_DIR/plugins/yabai/utility.sh"
  CURRENT_SPACE_ID="$1"
  RECENT_SPACE_ID="$2"

  CURRENT_SPACE_INDEX=$(get_space_index_from_id "$CURRENT_SPACE_ID")
  RECENT_SPACE_INDEX=$(get_space_index_from_id "$RECENT_SPACE_ID")

  if [ "$RECENT_SPACE_INDEX" = "" ]
  then
    refresh_bar
  else
    refresh_space "$CURRENT_SPACE_INDEX" &
    refresh_space "$RECENT_SPACE_INDEX" &
  fi
}

application_launched() {
  echo application_launched
}

application_front_switched() {
  # CURRENT_PROCESS_ID="$1"
  # refresh_windows_of_process "$CURRENT_PROCESS_ID" # Already covered by focused window, others app windows aren't impacted
  
  RECENT_PROCESS_ID="$2"
  refresh_windows_of_process "$RECENT_PROCESS_ID"
}

window_state_changed() {
  WINDOW_ID="$1"
  WINDOW=$(yabai -m query --windows --window "$WINDOW_ID")
  SPACE_INDEX=$(echo "$WINDOW" | jq '.space')

  refresh_space "$SPACE_INDEX"
}

# Use window_focused to detect actions and diff between current and recent yabai window

echo '  >>>> SENDER' $(date) $SENDER "$YABAI_PROCESS_ID" "$YABAI_RECENT_PROCESS_ID" "$YABAI_WINDOW_ID" "$YABAI_SPACE_ID" "$YABAI_DISPLAY_ID" "$YABAI_RECENT_SPACE_ID" "$YABAI_RECENT_DISPLAY_ID" "$SPACE_INDEX" "$WINDOW_ID" "$DISPLAY_ID"
# TODO: Resourcess optimization - Implement a queue to send refresh udpates to, processing messages with a minor arbitrary delay to remove duplicate request from overlapping yabai signal
# TODO: Delete unused signal and trigger from yabairc and items/yabai.sh
case "$SENDER" in
  # "application_launched") application_launched
  # ;;
  # "application_terminated") application_terminated
  # ;;
  "application_front_switched") application_front_switched "$YABAI_PROCESS_ID" "$YABAI_RECENT_PROCESS_ID"
  ;;
  # "application_activated") application_activated
  # ;;
  # "application_deactivated") application_deactivated
  # ;;
  "application_visible") refresh_windows_of_process "$YABAI_PROCESS_ID"
  ;;
  # "application_hidden") refresh_windows_of_process "$YABAI_PROCESS_ID" # Overlaps with application_front_switch as focus moves to previous window when app is hidden
  # ;;
  "window_created") create_window "$YABAI_WINDOW_ID"
  ;;
  "window_destroyed") destroy_window "$YABAI_WINDOW_ID"
  ;;
  # "window_focused") refresh_window "$YABAI_WINDOW_ID"
  "window_focused") window_state_changed "$YABAI_WINDOW_ID"
  ;;
  "window_moved") refresh_window "$YABAI_WINDOW_ID"
  ;;
  # "window_resized") window_resized
  # ;;
  "window_minimized") window_state_changed "$YABAI_WINDOW_ID"
  ;;
  # "window_deminimized") window_deminimized # Overlaps with window_focused, as window is focused by MacOS when deminimized by default
  # ;;
  # "window_title_changed") window_title_changed
  # ;;
  "space_changed") space_changed "$YABAI_SPACE_ID" "$YABAI_RECENT_SPACE_ID"
  ;;
  "display_added") refresh_display "$YABAI_DISPLAY_ID"
  ;;
  "display_removed") refresh_display "$YABAI_DISPLAY_ID"
  ;;
  # "display_moved") display_moved
  # ;;
  # "display_resized") display_resized
  # ;;
  "display_changed") display_changed "$YABAI_DISPLAY_ID" "$YABAI_RECENT_DISPLAY_ID"
  ;;
  # "mouse.clicked") mouse_clicked
  # ;;
  "refresh_space") refresh_space "$SPACE_INDEX"
  ;;
  "refresh_window") refresh_window "$WINDOW_ID"
  ;;
  # "refresh_display") refresh_display "$DISPLAY_ID"
  # ;;
  "window_moved") update_window_space "$WINDOW_ID" "$SPACE_INDEX"
  ;;
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
