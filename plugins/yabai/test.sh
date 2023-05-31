#!/bin/bash -x

# # Get the focused window ID
# window=$(yabai -m query --windows --window)
# focused_window_id=$(echo "$window" | jq -r '.id')

# # Get the bundle identifier of the focused application
# focused_app_bundle=$(echo "$window" | jq -r ".app")

# # Get the IDs of windows belonging to the focused application
# app_window_ids=$(yabai -m query --windows | jq -r ".[] | select(.app == \"${focused_app_bundle}\").id")

# # Get the current stack index of the focused window
# current_stack_index=$(echo "$window" | jq '.["stack-index"]')

# # Cycle through the window IDs and focus each window one by one
# for window_id in ${app_window_ids[@]}; do
#   # Skip the focused window initially
#   if [[ "$window_id" != "$focused_window_id" ]]; then
#     # Update the stack index of the window to the current stack index of the focused window
#     yabai -m window --stack "${window_id}" "${current_stack_index}"
#     # Focus the window
#     yabai -m window --focus "${window_id}"
#     break  # Exit the loop after focusing the first window
#   fi
# done

# sketchybar --trigger window_focused YABAI_WINDOW_ID=11302 &
# sketchybar --trigger space_changed YABAI_SPACE_ID=3 YABAI_RECENT_SPACE_ID=6 &
# sketchybar --trigger window_focused YABAI_WINDOW_ID=11302 &
# sketchybar --trigger space_changed YABAI_SPACE_ID=6 YABAI_RECENT_SPACE_ID=4 &

sketchybar --move yabai-window-90725 after yabai-space-2-head
sketchybar --trigger refresh_space SPACE_INDEX=2