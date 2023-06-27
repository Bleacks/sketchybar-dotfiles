source "$CONFIG_DIR/colors.sh"

space_icon_base=(
  label.padding_right=5
  label.padding_left=7
  label.highlight_color=$WHITE
  label.font="$FONT:Bold:14.0"
  y_offset=-0.5
)

space_bracket=(
  background.color=$BACKGROUND_1
  background.border_color=$BACKGROUND_2
  # background.highlight=off
  # background.highlight_color=$BLACK
)

window_item=(
  icon.drawing=on
  drawing=on
  icon.font.size=16
  icon.padding_left=0
  icon.padding_right=0
  icon.highlight_color=$WINDOW_HIGHLIGHT_COLOR
  y_offset=0.5
  label.drawing=off
  script="$PLUGIN_DIR/yabai/window.sh"
)

hidden_item=(
  drawing=off
)

space_splitter_base=(
  label.drawing=off
  icon.drawing=off
  width=0
)