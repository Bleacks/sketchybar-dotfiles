
#
# Utility functions
#

create_window() {
  source "$CONFIG_DIR/colors.sh"

  WINDOW_ID="$1"
  WINDOW=$(yabai -m query --windows --window "$WINDOW_ID")
  SPACE_ID=$(echo "$WINDOW" | jq '."space"')
  APP=$(echo "$WINDOW" | jq '."app"')

  FILTERED_APP=$(echo "$APP" | grep -E "$YABAI_IGNORED_APP_REGEX")

  if ! [ "$FILTERED_APP" = "" ]
  then

    ITEM_NAME="yabai-window-${WINDOW_ID}"
    ICON_NAME=$($CONFIG_DIR/plugins/icon_map.sh "$APP")
    
    sketchybar \
        --add item "$ITEM_NAME" left \
        --set "$ITEM_NAME" \
          icon="$ICON_NAME" \
          icon.color=$WINDOW_DEFAULT_COLOR \
          icon.drawing=on \
          drawing=on \
          icon.font.size=16 \
          icon.padding_left=0 \
          icon.padding_right=0 \
          y_offset=0.5
    # windows=$(echo $windows "$ITEM_NAME")
  fi
  # FIXME: Reorder windows afterwards to insert new one in space, and then display it all with animate. Here or in application_launched ?
}

destroy_window() {
  WINDOW_ID="$1"
  sketchybar --remove "yabai-window-$WINDOW_ID"
  # FIXME: Handle cases where space is destroyed as well
  # FIXME: Need to reorder afterwards ? 
}