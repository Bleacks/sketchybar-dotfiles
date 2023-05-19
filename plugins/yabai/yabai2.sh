
# window_state() {
#   source "$CONFIG_DIR/colors.sh"
#   source "$CONFIG_DIR/icons.sh"

#   echo "state"

#   WINDOW=$(yabai -m query --windows --window)
#   STACK_INDEX=$(echo "$WINDOW" | jq '.["stack-index"]')
#   SPACE_ID=$(echo "$WINDOW" | jq '.["space"]')

#   COLOR=$BAR_BORDER_COLOR
#   ICON=""

#   sketchybar --set yabai-space-$SPACE_ID color=$COLOR

#   if [ "$(echo "$WINDOW" | jq '.["is-floating"]')" = "true" ]; then
#     ICON+=$YABAI_FLOAT
#     COLOR=$MAGENTA
#   elif [ "$(echo "$WINDOW" | jq '.["has-fullscreen-zoom"]')" = "true" ]; then
#     ICON+=$YABAI_FULLSCREEN_ZOOM
#     COLOR=$GREEN
#   elif [ "$(echo "$WINDOW" | jq '.["has-parent-zoom"]')" = "true" ]; then
#     ICON+=$YABAI_PARENT_ZOOM
#     COLOR=$BLUE
#   elif [[ $STACK_INDEX -gt 0 ]]; then
#     LAST_STACK_INDEX=$(yabai -m query --windows --window stack.last | jq '.["stack-index"]')
#     ICON+=$YABAI_STACK
#     LABEL="$(printf "[%s/%s]" "$STACK_INDEX" "$LAST_STACK_INDEX")"
#     COLOR=$RED
#   fi

#   args=(--animate sin 10 --bar border_color=$COLOR
#                          --set $NAME icon.color=$COLOR)

#   [ -z "$LABEL" ] && args+=(label.width=0) \
#                   || args+=(label="$LABEL" label.width=40)

#   [ -z "$ICON" ] && args+=(icon.width=0) \
#                  || args+=(icon="$ICON" icon.width=30)

#   sketchybar -m "${args[@]}"
# }

# update_spaces () {
#   source "$CONFIG_DIR/colors.sh"

#   ALL_SPACES=$(yabai -m query --spaces)
#   ALL_SPACES_ID=$(echo "$ALL_SPACES" | jq '.[].index')
  
#   # ACTIVE_SPACE=$(echo "$ALL_SPACES" | jq '.[] | select(.["has-focus"] == true)')

#   # sketchybar --set "yabai-space-${ACTIVE_SPACE}-bracket" background.color=$RED
#   while read -r line
#   do
#     for SPACE_ID in $line
#     do
      
#       SPACE="$(yabai -m query --spaces --space "$SPACE_ID")"
#       SPACE_HAS_FOCUS=$(echo "$SPACE" | jq '."has-focus"')
#       SPACE_IS_FULLSCREEN=$(echo "$SPACE" | jq '."is-native-fullscreen"')

#       COLOR=$SPACE_BORDER_DEFAULT
#       if [ "$SPACE_IS_FULLSCREEN" = "true" ]; then
#         COLOR=$SPACE_BORDER_FULLSCREEN
#         BACKGROUND_COLOR=$SPACE_BACKGROUND_FULLSCREEN
#         sketchybar --animate sin 10 --set "yabai-space-${SPACE_ID}" label.highlight=on # TODO: Implement color shifting through highlight
#         WINDOW_ID=$(yabai -m query --windows --space "$SPACE_ID" | jq '.[].id')
#         sketchybar --animate sin 10 --set "yabai-space-${SPACE_ID}-${WINDOW_ID}" icon.highlight=on

#       elif [ "$SPACE_HAS_FOCUS" = "true" ]; then
#         COLOR=$SPACE_BORDER_FOCUSED
#       fi
#       # echo $SPACE_ID $SPACE_HAS_FOCUS $SPACE_IS_FULLSCREEN $COLOR

#       sketchybar --animate sin 10 --set "yabai-space-${SPACE_ID}-bracket" background.border_color="$COLOR" background.color="$BACKGROUND_COLOR"
#     done
#   done <<< "$ALL_SPACES_ID"

#   # sketchybar -m "${args[@]}"
# }

# refresh_window() {
#   source "$CONFIG_DIR/colors.sh"
#   WINDOW="$1"

#   WINDOW_ID=$(echo "$WINDOW" | jq '."id"')
#   WINDOW_HAS_FOCUS=$(echo "$WINDOW" | jq '."has-focus"')
#   WINDOW_IS_FULLSCREEN=$(echo "$WINDOW" | jq '."is-native-fullscreen"')
#   WINDOW_IS_MINIMIZED=$(echo "$WINDOW" | jq '."is-minimized"')
#   WINDOW_IS_HIDDEN=$(echo "$WINDOW" | jq '."is-hidden"')
#   SPACE_ID=$(echo "$WINDOW" | jq '."space"')

#   COLOR=$WINDOW_DEFAULT_COLOR
#   if [ "$WINDOW_IS_FULLSCREEN" = "true" ]; then
#     # COLOR=$SPACE_BORDER_FULLSCREEN
#     # BACKGROUND_COLOR=$SPACE_BACKGROUND_FULLSCREEN
#     # sketchybar --animate sin 10 --set "yabai-space-${SPACE_ID}" label.highlight=on # TODO: Implement color shifting through highlight
#     # WINDOW_ID=$(yabai -m query --windows --space "$SPACE_ID" | jq '.[].id')
#     COLOR=$WINDOW_FULLSCREEN_COLOR

#   elif [ "$WINDOW_HAS_FOCUS" = "true" ]; then
#     # COLOR=$SPACE_BORDER_FOCUSED
#     COLOR=$WINDOW_FOCUSED_COLOR
  
#   elif [ "$WINDOW_IS_MINIMIZED" = "true" ]; then
#     COLOR=$WINDOW_MINIMIZED_COLOR
  
#   elif [ "$WINDOW_IS_HIDDEN" = "true" ]; then
#     COLOR=$WINDOW_HIDDEN_COLOR
  
#   fi
#   # echo "yabai-space-${SPACE_ID}-${WINDOW_ID}"
#   sketchybar --animate sin 10 --set "yabai-space-${SPACE_ID}-${WINDOW_ID}" icon.color=$COLOR
# }

# update_windows() {

#   ALL_WINDOWS=$(yabai -m query --windows)
#   ALL_WINDOWS_ID=$(echo "$ALL_WINDOWS" | jq '.[].id')

#   # sketchybar --set "yabai-space-${ACTIVE_SPACE}-bracket" background.color=$RED
#   while read -r WINDOW_ID
#   do
#     WINDOW="$(yabai -m query --windows --window "$WINDOW_ID")"
#     echo $WINDOW
#     WINDOW_APP="$(yabai -m query --windows | jq --arg FILTER "$WINDOW_ID" '. | map(select(.app == $FILTER))')"
    
#     filtered_result=$(echo "$WINDOW_APP" | grep -E "$YABAI_IGNORED_APP_REGEX")
#     if ! [ "$filtered_result" = "" ]; then

#       refresh_window "$WINDOW"
#       # echo $SPACE_ID $SPACE_HAS_FOCUS $SPACE_IS_FULLSCREEN $COLOR

#       # sketchybar --animate sin 10 --set "yabai-space-${SPACE_ID}-bracket" background.border_color="$COLOR" background.color="$BACKGROUND_COLOR"
#     fi
#   done <<< "$ALL_WINDOWS_ID"
# }

# update_front_app() {
#   PREVIOUS_WINDOW="$(yabai -m query --windows --window recent)"
#   CURRENT_WINDOW="$(yabai -m query --windows --window)"
#   echo $PREVIOUS_WINDOW
#   echo $CURRENT_WINDOW
#   refresh_window "$PREVIOUS_WINDOW" &
#   refresh_window "$CURRENT_WINDOW" &
# }

# mouse_clicked() {
#   # yabai -m window --toggle float
#   window_state
# }

# update_spaces
# update_windows

