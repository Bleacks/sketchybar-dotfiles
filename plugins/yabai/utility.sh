source "$CONFIG_DIR/plugins/yabai/styles.sh"
source "$CONFIG_DIR/plugins/yabai/config.sh"

SPACE_PREFIX="yabai-space"
WINDOW_PREFIX="yabai-window"

#
# Common functions
#

get_space_item_name() {
  SPACE_INDEX="$1"
  echo "${SPACE_PREFIX}-${SPACE_INDEX}"
}

get_window_item_name() {
  WINDOW_ID="$1"
  echo "${WINDOW_PREFIX}-${WINDOW_ID}"
}

get_space_head_item_name() {
  SPACE_INDEX="$1"
  SPACE_ITEM_NAME=$(get_space_item_name "$SPACE_INDEX")
  echo "$SPACE_ITEM_NAME-head"
}

get_space_tail_item_name() {
  SPACE_INDEX="$1"
  SPACE_ITEM_NAME=$(get_space_item_name "$SPACE_INDEX")
  echo "$SPACE_ITEM_NAME-tail"
}

get_space_bracket_item_name() {
  SPACE_INDEX="$1"
  SPACE_ITEM_NAME=$(get_space_item_name "$SPACE_INDEX")
  echo "$SPACE_ITEM_NAME-bracket"
}

get_space_index_from_id() {
  SPACE_ID="$1"
  ALL_SPACES=$(yabai -m query --spaces)
  SPACE_INDEX=$(echo "$ALL_SPACES" | jq --arg FILTER "$SPACE_ID" '.[] | select(.["id"] == ($FILTER | tonumber)) | .index')
  echo "$SPACE_INDEX"
}

#
# Utility functions
#

refresh_window() {
  source "$CONFIG_DIR/colors.sh"
  WINDOW_ID="$1"

  WINDOW=$(yabai -m query --windows --window "$WINDOW_ID")
  WINDOW_IS_FULLSCREEN=$(echo "$WINDOW" | jq '."is-native-fullscreen"')
  WINDOW_IS_HIDDEN=$(echo "$WINDOW" | jq '."is-hidden"')
  WINDOW_IS_MINIMIZED=$(echo "$WINDOW" | jq '."is-minimized"')
  WINDOW_HAS_FOCUS=$(echo "$WINDOW" | jq '."has-focus"')
  SPACE_INDEX=$(echo "$WINDOW" | jq '."space"')

  WINDOW_ROLE=$(echo "$WINDOW" | jq -r '.role')
  WINDOW_TITLE=$(echo "$WINDOW" | jq -r '.title')

  COLOR=$WINDOW_DEFAULT_COLOR

  WINDOW_ITEM_NAME=$(get_window_item_name "$WINDOW_ID")
  SPACE_ITEM_NAME=$(get_space_item_name "$SPACE_INDEX")
  
  if [ "$WINDOW_IS_FULLSCREEN" ] || [ "$WINDOW_IS_HIDDEN" ] || [ "$WINDOW_IS_MINIMIZED" ] || [ "$WINDOW_HAS_FOCUS" ]
  then
    if [ "$WINDOW_IS_FULLSCREEN" = "true" ]
    then
      COLOR="$WINDOW_FULLSCREEN_COLOR"

    elif [ "$WINDOW_IS_HIDDEN" = "true" ]
    then
      COLOR="$WINDOW_HIDDEN_COLOR"
      SPACE_TAIL_ITEM_NAME=$(get_space_tail_item_name "$SPACE_INDEX")

    elif [ "$WINDOW_IS_MINIMIZED" = "true" ]
    then
      COLOR="$WINDOW_MINIMIZED_COLOR"
      SPACE_TAIL_ITEM_NAME=$(get_space_tail_item_name "$SPACE_INDEX")

    elif [ "$WINDOW_HAS_FOCUS" = "true" ]
    then
      COLOR="$WINDOW_FOCUSED_COLOR"
      SPACE_HEAD_ITEM_NAME=$(get_space_head_item_name "$SPACE_INDEX")
    fi
  fi

  WINDOW_ITEM_NAME=$(get_window_item_name "$WINDOW_ID")
  sketchybar --animate sin 10 --set "$WINDOW_ITEM_NAME" icon.color=$COLOR
}

create_window() {
  source "$CONFIG_DIR/colors.sh"
  # FIXME: Ignore tooltip in applications

  WINDOW_ID="$1"
  WINDOW=$(yabai -m query --windows --window "$WINDOW_ID")
  WINDOW_ROLE=$(echo "$WINDOW" | jq -r '.role')
  WINDOW_TITLE=$(echo "$WINDOW" | jq -r '.title')
  if [ "$WINDOW_ROLE" != "AXHelpTag" ] && [ "$WINDOW_TITLE" != "" ]
  then
    SPACE_ID=$(echo "$WINDOW" | jq '.space')

    WINDOW_APP=$(echo "$WINDOW" | jq -r '.app')
    IS_VISIBLE="$(echo "$WINDOW_APP" | grep -E "$YABAI_IGNORED_APP_REGEX")$(echo "$WINDOW_TITLE" | grep -E "$YABAI_IGNORED_TITLE_REGEX")"
    
    WINDOW_ITEM_NAME=$(get_window_item_name "$WINDOW_ID")
    SPACE_ITEM_NAME=$(get_space_item_name "$SPACE_INDEX")

    ICON_NAME=""
    if [ "$IS_VISIBLE" = "" ]
    then
      ICON_NAME=$($CONFIG_DIR/plugins/icon_map.sh "$WINDOW_APP")
    fi

    sketchybar  --animate sin 5                               \
                --add item "$WINDOW_ITEM_NAME" left                  \
                --set "$WINDOW_ITEM_NAME"  "${window_icon_base[@]}"  \
                                    icon="$ICON_NAME"         \
                                    icon.color=$WINDOW_DEFAULT_COLOR
    
    SPACE_INDEX=$(get_space_index_from_id "$SPACE_ID")
    SPACE_HEAD_ITEM_NAME=$(get_space_head_item_name "$SPACE_ID")
    
    sketchybar --move "$WINDOW_ITEM_NAME" after "$SPACE_HEAD_ITEM_NAME"

    # refresh_window "$WINDOW_ID" &
    # refresh_space "$SPACE_INDEX" &
  fi
  # FIXME: Reorder windows afterwards to insert new one in space, and then display it all with animate. Here or in application_launched ?
}

destroy_window() {
  WINDOW_ID="$1"
  WINDOW_ITEM_NAME=$(get_window_item_name "$WINDOW_ID")
  sketchybar --remove "$WINDOW_ITEM_NAME"
  # FIXME: Handle cases where space is destroyed as well
  # FIXME: Need to reorder afterwards ? 
}

create_space_head() {
  SPACE_INDEX="$1"
  SPACE_HEAD_ITEM_NAME=$(get_space_head_item_name "$SPACE_INDEX")

  sketchybar  --add item "$SPACE_HEAD_ITEM_NAME" left  \
              --set "$SPACE_HEAD_ITEM_NAME"            \
                    label="$SPACE_INDEX"             \
                    "${space_icon_base[@]}"

  echo "$SPACE_HEAD_ITEM_NAME"
}

create_space_windows_splitter() {
  SPACE_SPACER_NAME="$1"
  sketchybar  --add item "$SPACE_SPACER_NAME" left "${space_windows_splitter_base[@]}"
}

create_spacer() {
  SPACE_SPACER_NAME="$1"
  sketchybar  --add item "$SPACE_SPACER_NAME" left "${space_splitter_base[@]}"
}

create_space_tail() {
  SPACE_INDEX="$1"
  SPACE_TAIL_ITEM_NAME=$(get_space_tail_item_name "$SPACE_INDEX")

  create_spacer "$SPACE_TAIL_ITEM_NAME"
  echo "$SPACE_TAIL_ITEM_NAME"
}

create_space_bracket() {
  SPACE_INDEX="$1"
  SPACE_BRACKET_ITEM_NAME=$(get_space_bracket_item_name "$SPACE_INDEX")
  SPACE_ITEM_NAME=$(get_space_item_name "$SPACE_INDEX")
  sketchybar  --animate sin 7  \
              --add bracket "$SPACE_BRACKET_ITEM_NAME" "/${SPACE_ITEM_NAME}-.*/" \
              --set "$SPACE_BRACKET_ITEM_NAME" "${space_bracket[@]}"
  echo "$SPACE_BRACKET_ITEM_NAME"
}

create_space() {
  SPACE_INDEX="$1"
  SPACE=$(yabai -m query --spaces --space "$SPACE_INDEX")
  SPACE_ITEM_NAME=$(get_space_item_name "$SPACE_INDEX")
  WINDOWS_ID_IN_SPACE=$(echo "$SPACE" | jq -r '.windows[]')

  SPACE_HEAD_ITEM_NAME=$(create_space_head "$SPACE_INDEX")
  
  while read -r WINDOW_ID
  do
    WINDOW_ITEM_NAME=$(create_window "$WINDOW_ID")

  done <<< "$WINDOWS_ID_IN_SPACE"

  SPACE_TAIL_ITEM_NAME=$(create_space_tail "$SPACE_INDEX")

  SPACE_BRACKET_ITEM_NAME=$(create_space_bracket "$SPACE_INDEX")

  # FIXME: Find out why a window icon is added to space when no window are in space

  SPACE_SPLITTER_NAME="${SPACE_ITEM_NAME}-splitter"
  create_spacer "$SPACE_SPLITTER_NAME"


  refresh_space "$SPACE_INDEX" &
}

update_window_space() {
  WINDOW_ID="$1"
  SPACE_INDEX="$2"

  WINDOW_ITEM_NAME=$(get_window_item_name "$WINDOW_ID")
  SPACE_HEAD_ITEM_NAME=$(get_space_head_item_name "$SPACE_INDEX")

  sketchybar --move "$WINDOW_ITEM_NAME" after "$SPACE_HEAD_ITEM_NAME"
  refresh_space "$SPACE_INDEX"
}

reorder_window_list() {
  WINDOW_IDS="$1"

  FOCUSED_WINDOW=""
  FULLSCREEN_WINDOWS=""
  HIDDEN_WINDOWS=""
  MINIMIZED_WINDOWS=""
  NORMAL_WINDOWS=""

  while read -r WINDOW_ID
  do
    WINDOW=$(yabai -m query --windows --window "$WINDOW_ID")
    WINDOW_ITEM_NAME=$(get_window_item_name "$WINDOW_ID")
    WINDOW_IS_FULLSCREEN=$(echo "$WINDOW" | jq '."is-native-fullscreen"')
    WINDOW_IS_HIDDEN=$(echo "$WINDOW" | jq '."is-hidden"')
    WINDOW_IS_MINIMIZED=$(echo "$WINDOW" | jq '."is-minimized"')
    WINDOW_IS_TOPMOST=$(echo "$WINDOW" | jq '."is-topmost"')
    
    if [ "$WINDOW_IS_FULLSCREEN" = "true" ]
    then
      FULLSCREEN_WINDOWS="$FULLSCREEN_WINDOWS $WINDOW_ITEM_NAME"

    elif [ "$WINDOW_IS_HIDDEN" = "true" ]
    then
      HIDDEN_WINDOWS="$HIDDEN_WINDOWS $WINDOW_ITEM_NAME"

    elif [ "$WINDOW_IS_MINIMIZED" = "true" ]
    then
      MINIMIZED_WINDOWS="$MINIMIZED_WINDOWS $WINDOW_ITEM_NAME"

    elif [ "$WINDOW_IS_TOPMOST" = "true" ]
    then
      TOPMOST_WINDOWS="$TOPMOST_WINDOWS $WINDOW_ITEM_NAME"

    else
      NORMAL_WINDOWS="$NORMAL_WINDOWS $WINDOW_ITEM_NAME"
    fi
  done <<< "$WINDOW_IDS"

  sketchybar --reorder $TOPMOST_WINDOWS $FULLSCREEN_WINDOWS $NORMAL_WINDOWS $HIDDEN_WINDOWS $MINIMIZED_WINDOWS
}

refresh_window_list() {
  WINDOW_IDS="$1"
  while read -r WINDOW_ID
  do
    refresh_window "$WINDOW_ID" &
  done <<< "$WINDOW_IDS"
}

refresh_windows_of_process () {
  PROCESS_ID="$1"
  WINDOWS_IDS=$(yabai -m query --windows | jq --arg FILTER "$PROCESS_ID" '.[] | select(.pid == ($FILTER | tonumber)) | .id')
  
  refresh_window_list "$WINDOWS_IDS" 
  # for WINDOW_ID in $WINDOWS_IDS
  # do
  #   refresh_window "$WINDOW_ID" &
  # done
}

# TODO: make use of Yabai's stack-index field to order windows
refresh_windows_in_space() {
  SPACE_INDEX="$1"
  SPACE=$(yabai -m query --spaces --space "$SPACE_INDEX")
  WINDOWS_ID_IN_SPACE=$(echo "$SPACE" | jq -r '.windows[]')

  refresh_window_list "$WINDOWS_ID_IN_SPACE" &
  # while read -r WINDOW_ID
  # do
  #   WINDOW_ITEM_NAME=$(refresh_window "$WINDOW_ID")
  # done <<< "$WINDOWS_ID_IN_SPACE"
  reorder_window_list "$WINDOWS_ID_IN_SPACE"
} 


refresh_space() {
  SPACE_INDEX="$1"
  SPACE=$(yabai -m query --spaces --space "$SPACE_INDEX")

  SPACE_HAS_FOCUS=$(echo "$SPACE" | jq '."has-focus"')
  SPACE_IS_FULLSCREEN=$(echo "$SPACE" | jq '."is-native-fullscreen"')

  BORDER_COLOR=$SPACE_BORDER_DEFAULT
  BACKGROUND_COLOR=$SPACE_BACKGROUD_DEFAULT
  LABEL_COLOR=$WINDOW_DEFAULT_COLOR
  if [ "$SPACE_IS_FULLSCREEN" = "true" ]
  then
    BORDER_COLOR=$SPACE_BORDER_FULLSCREEN
    BACKGROUND_COLOR=$SPACE_BACKGROUND_FULLSCREEN
    LABEL_COLOR=$WINDOW_FULLSCREEN_COLOR
    # TODO: Implement color shifting through highlight
    WINDOW_ID=$(yabai -m query --windows --space "$SPACE_INDEX" | jq '.[].id')

  elif [ "$SPACE_HAS_FOCUS" = "true" ]
  then
    BORDER_COLOR=$SPACE_BORDER_FOCUSED
  fi

  SPACE_ITEM_NAME=$(get_space_item_name "$SPACE_INDEX")
  SPACE_HEAD_ITEM_NAME=$(get_space_head_item_name "$SPACE_INDEX")
  SPACE_BRACKET_NAME=$(get_space_bracket_item_name "$SPACE_INDEX")
  sketchybar  --animate sin 10 \
              --set "$SPACE_BRACKET_NAME" \
                    background.border_color="$BORDER_COLOR" \
                    background.color="$BACKGROUND_COLOR" \
                    label.color="$LABEL_COLOR" \
              --set "${SPACE_HEAD_ITEM_NAME}" \
                    label.color="$LABEL_COLOR"

  refresh_windows_in_space "$SPACE_INDEX"
}

create_bar() {
  CURRENT_SPACES="$(yabai -m query --spaces | jq -r '.[].index | @sh')"

  create_spacer "yabai-start"
  create_spacer "yabai-end"

  while read -r LINE
  do
    for SPACE_INDEX in $LINE
    do
      create_space "$SPACE_INDEX"
    done
  done <<< "$CURRENT_SPACES"
}