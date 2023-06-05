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

create_bar

sketchybar  \
            --add event application_front_switched  \
            --add event application_visible         \
            --add event window_created              \
            --add event window_destroyed            \
            --add event window_focused              \
            --add event window_resized              \
            --add event window_minimized            \
            --add event space_changed               \
            --add event display_added               \
            --add event display_removed             \
            --add event display_moved               \
            --add event display_resized             \
            --add event display_changed             \
            --add event refresh_space               \
            --add event refresh_window              \
            --add event refresh_display             \
            --add event window_moved

            # --add event window_title_changed        \
            # --add event application_launched        \
            # --add event application_terminated      \
            # --add event application_activated       \
            # --add event application_deactivated     \
            # --add event application_hidden          \
            # --add event window_moved                \
            # --add event window_deminimized          \

sketchybar  \
            --subscribe yabai-helper application_front_switched \
            --subscribe yabai-helper application_visible        \
            --subscribe yabai-helper window_created             \
            --subscribe yabai-helper window_destroyed           \
            --subscribe yabai-helper window_focused             \
            --subscribe yabai-helper window_resized             \
            --subscribe yabai-helper window_minimized           \
            --subscribe yabai-helper space_changed              \
            --subscribe yabai-helper display_added              \
            --subscribe yabai-helper display_removed            \
            --subscribe yabai-helper display_moved              \
            --subscribe yabai-helper display_resized            \
            --subscribe yabai-helper display_changed            \
            --subscribe yabai-helper refresh_space              \
            --subscribe yabai-helper refresh_window             \
            --subscribe yabai-helper refresh_display            \
            --subscribe yabai-helper window_moved

            # --subscribe yabai-helper window_title_changed       \
            # --subscribe yabai-helper application_launched       \
            # --subscribe yabai-helper application_terminated     \
            # --subscribe yabai-helper application_activated      \
            # --subscribe yabai-helper application_deactivated    \
            # --subscribe yabai-helper application_hidden         \
            # --subscribe yabai-helper window_moved               \
            # --subscribe yabai-helper window_deminimized         \
