keyboard=(
  icon=􀐛
  label=?
  script="$PLUGIN_DIR/keyboard.sh"
)

sketchybar --add event input_change 'AppleSelectedInputSourcesChangedNotification' \
           --add item keyboard right   \
           --set keyboard "${keyboard[@]}" \
           --subscribe keyboard input_change

