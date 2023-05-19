source "$CONFIG_DIR/plugins/yabai/styles.sh"

#
# Utility functions
#

create_window() {
  source "$CONFIG_DIR/colors.sh"

  WINDOW_ID="$1"
  WINDOW=$(yabai -m query --windows --window "$WINDOW_ID")
  SPACE_ID=$(echo "$WINDOW" | jq '.space')
  APP=$(echo "$WINDOW" | jq -r '.app')

  IS_VISIBLE=$(echo "$APP" | grep -E "$YABAI_IGNORED_APP_REGEX")
  ITEM_NAME="yabai-window-${WINDOW_ID}"

  ICON_NAME=""
  if [ "$IS_VISIBLE" = "" ]
  then
    ICON_NAME=$($CONFIG_DIR/plugins/icon_map.sh "$APP")
  fi
    
  sketchybar  --add item "$ITEM_NAME" left                  \
              --set "$ITEM_NAME"  "${window_icon_base[@]}"  \
                                  icon="$ICON_NAME"         \
                                  icon.color=$WINDOW_DEFAULT_COLOR
                                  
    # windows=$(echo $windows "$ITEM_NAME")
  # FIXME: Reorder windows afterwards to insert new one in space, and then display it all with animate. Here or in application_launched ?
}

destroy_window() {
  WINDOW_ID="$1"
  sketchybar --remove "yabai-window-$WINDOW_ID"
  # FIXME: Handle cases where space is destroyed as well
  # FIXME: Need to reorder afterwards ? 
}

refresh_space() {
  SPACE_ID="$1"
  # SPACE=$(yabai -m query --spaces | jq --arg FILTER "$SPACE_ID" '. | map(select(.id == $FILTER))')
  SPACE=$(yabai -m query --spaces --space "$SPACE_ID")
  SPACE_HAS_FOCUS=$(echo "$SPACE" | jq '."has-focus"')
  SPACE_IS_FULLSCREEN=$(echo "$SPACE" | jq '."is-native-fullscreen"')

  COLOR=$SPACE_BORDER_DEFAULT
  if [ "$SPACE_IS_FULLSCREEN" = "true" ]; then
    COLOR=$SPACE_BORDER_FULLSCREEN
    BACKGROUND_COLOR=$SPACE_BACKGROUND_FULLSCREEN
    sketchybar --animate sin 10 --set "yabai-space-${SPACE_ID}" label.highlight=on # TODO: Implement color shifting through highlight
    WINDOW_ID=$(yabai -m query --windows --space "$SPACE_ID" | jq '.[].id')
    sketchybar --animate sin 10 --set "yabai-space-${SPACE_ID}-${WINDOW_ID}" icon.highlight=on

  elif [ "$SPACE_HAS_FOCUS" = "true" ]; then
    COLOR=$SPACE_BORDER_FOCUSED
  fi
  # echo $SPACE_ID $SPACE_HAS_FOCUS $SPACE_IS_FULLSCREEN $COLOR

  sketchybar --animate sin 10 --set "yabai-space-${SPACE_ID}-bracket" background.border_color="$COLOR" background.color="$BACKGROUND_COLOR"
}