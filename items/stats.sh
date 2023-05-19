#!/usr/bin/env bash
source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

cpu_percent=(
	# label.font="$FONT:Heavy:12"
	label=" - %"
	label.color="$WHITE"
	icon="$CPU"
	icon.padding_left=10
	icon.padding_right=3
	# icon.color="$BLUE"
	update_freq=5
	mach_helper="$HELPER"
)

sketchybar 	--add item cpu.percent right 					\
						--set cpu.percent "${cpu_percent[@]}"


memory=(
  # label.font="$FONT:Heavy:12"
	# label.color="$TEXT"
	icon="$MEMORY"
	icon.padding_left=10
	icon.padding_right=3
	icon.font="SF Pro:Bold:16.0"
	# icon.color="$GREEN"
	update_freq=5
	script="$PLUGIN_DIR/stats/ram.sh"
)

sketchybar 	--add item memory right 		\
						--set memory "${memory[@]}"

# disk=(
# 	label.font="$FONT:Heavy:12"
# 	label.color="$TEXT"
# 	icon="$DISK"
# 	icon.color="$MAROON"
# 	update_freq=60
# 	script="$PLUGIN_DIR/stats/disk.sh"
# )

# sketchybar --add item disk right 		\
# 					 --set disk "${disk[@]}"

# network_down=(
# 	y_offset=-7
# 	label.font="$FONT:Heavy:10"
# 	label.color="$TEXT"
# 	icon="$NETWORK_DOWN"
# 	icon.font="$NERD_FONT:Bold:16.0"
# 	icon.color="$GREEN"
# 	icon.highlight_color="$BLUE"
# 	update_freq=1
# )

# network_up=(
# 	background.padding_right=-70
# 	y_offset=7
# 	label.font="$FONT:Heavy:10"
# 	label.color="$TEXT"
# 	icon="$NETWORK_UP"
# 	icon.font="$NERD_FONT:Bold:16.0"
# 	icon.color="$GREEN"
# 	icon.highlight_color="$BLUE"
# 	update_freq=1
# 	script="$PLUGIN_DIR/stats/network.sh"
# )

# sketchybar 	--add item network.down right 						\
# 						--set network.down "${network_down[@]}" 	\
# 						--add item network.up right 							\
# 						--set network.up "${network_up[@]}"


# separator_right=(
# 	icon=
# 	icon.font="$NERD_FONT:Regular:16.0"
# 	background.padding_left=10
# 	background.padding_right=15
# 	label.drawing=off
# 	click_script='sketchybar --trigger toggle_stats'
# 	icon.color="$TEXT"
# )

# sketchybar  --add item separator_right right \
# 	          --set separator_right "${separator_right[@]}"