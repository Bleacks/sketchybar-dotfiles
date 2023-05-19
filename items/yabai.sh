#!/bin/bash

source "$YABAI_PLUGIN_DIR/utility.sh"
source "$YABAI_PLUGIN_DIR/styles.sh"

yabai=(
  script="$YABAI_PLUGIN_DIR/listeners.sh"
  icon.font="$FONT:Bold:16.0"
  # associated_display=active
  # ignore_association=on
)

sketchybar --add item yabai-helper left --set yabai-helper "${yabai[@]}" drawing=on

space_bracket=(
  background.color=$BACKGROUND_1
  background.border_color=$BACKGROUND_2
  # background.highlight=off
  # background.highlight_color=$BLACK
)
SPACE_PREFIX="yabai-space"
WINDOW_PREFIX="yabai-window"

CURRENT_SPACES="$(yabai -m query --spaces | jq -r '.[].index | @sh')"

while read -r LINE
do
  for SPACE_INDEX in $LINE
  do
    SPACE_ITEM_NAME="$SPACE_PREFIX-$SPACE_INDEX"
    SPACE_ID_ITEM_NAME="$SPACE_ITEM_NAME-id"

    sketchybar  --add item "$SPACE_ID_ITEM_NAME" left  \
                --set "$SPACE_ID_ITEM_NAME"            \
                      label="$SPACE_INDEX"             \
                      "${space_icon_base[@]}"
              
    SPACE=$(yabai -m query --spaces --space "$SPACE_INDEX")
    SPACE_ID=$(echo "$SPACE" | jq '.id')
    ALL_SPACE_WINDOWS_ID=$(echo "$SPACE" | jq -r '.windows[]')

    ITEMS_TO_BRACKET="$SPACE_ID_ITEM_NAME"
    
    while read -r WINDOW_ID
    do
      create_window "$WINDOW_ID"
      
      WINDOW_ITEM_NAME="$WINDOW_PREFIX-$WINDOW_ID"
      ITEMS_TO_BRACKET=$(echo $ITEMS_TO_BRACKET "$WINDOW_ITEM_NAME")

    done <<< "$ALL_SPACE_WINDOWS_ID"
    
    sketchybar  --animate sin 7  \
                --add bracket "$SPACE_ITEM_NAME-bracket" $ITEMS_TO_BRACKET \
                --set "$SPACE_ITEM_NAME-bracket" "${space_bracket[@]}"
      
    if [ "$ALL_SPACE_WINDOWS_ID" != "" ]
    then
      LAST_WINDOW_ID=$(echo "$ALL_SPACE_WINDOWS_ID" | tail -n1)
      
      if [ "$LAST_WINDOW_ID" != "" ]
      then
        sketchybar --set "$WINDOW_PREFIX-$LAST_WINDOW_ID" icon.padding_right=7
      fi
    fi
    
    # FIXME: Find out why a window icon is added to space when no window are in space

    sketchybar  --add item "$SPACE_ITEM_NAME-splitter" left "${space_splitter_base[@]}"
    
    SPACE_ID=$(echo "$SPACE" | jq '.id')
    refresh_space "$SPACE_ID"
  done
done <<< "$CURRENT_SPACES"

sketchybar  --add event application_launched        #\
            # --add event application_terminated      \
            # --add event application_front_switched  \
            # --add event application_activated       \
            # --add event application_deactivated     \
            # --add event application_visible         \
            # --add event application_hidden          \
sketchybar  --add event window_created              \
            --add event window_destroyed            \
            --add event window_focused              #\
            # --add event window_moved                \
            # --add event window_resized              \
            # --add event window_minimized            \
            # --add event window_deminimized          \
            # --add event window_title_changed        \
sketchybar  --add event space_changed               #\
            # --add event display_added               \
            # --add event display_removed             \
            # --add event display_moved               \
            # --add event display_resized             \
            # --add event display_changed

sketchybar  --subscribe yabai-helper application_launched       #\
#             --subscribe yabai-helper application_terminated     \
#             --subscribe yabai-helper application_front_switched \
#             --subscribe yabai-helper application_activated      \
#             --subscribe yabai-helper application_deactivated    \
#             --subscribe yabai-helper application_visible        \
#             --subscribe yabai-helper application_hidden         \
sketchybar  --subscribe yabai-helper window_created             \
            --subscribe yabai-helper window_destroyed           \
            --subscribe yabai-helper window_focused             #\
#             --subscribe yabai-helper window_moved               \
#             --subscribe yabai-helper window_resized             \
#             --subscribe yabai-helper window_minimized           \
#             --subscribe yabai-helper window_deminimized         \
#             --subscribe yabai-helper window_title_changed       \
sketchybar  --subscribe yabai-helper space_changed              #\
#             --subscribe yabai-helper display_added              \
#             --subscribe yabai-helper display_removed            \
#             --subscribe yabai-helper display_moved              \
#             --subscribe yabai-helper display_resized            \
#             --subscribe yabai-helper display_changed 
