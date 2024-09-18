#!/usr/bin/env sh

update_media() {
  STATE="$(echo "$INFO" | jq -r '.state')"

  if [ "$STATE" = "playing" ]; then
    MEDIA="$(echo "$INFO" | jq -r '.title + " - " + .artist')"
    sketchybar --set weather drawing=off
    sketchybar --set $NAME label="$MEDIA" drawing=on icon.background.drawing=on
  else
    sketchybar --set $NAME drawing=off icon.background.drawing=off
    sketchybar --set weather drawing=on
  fi
}

case "$SENDER" in
  "media_change") update_media
  ;;
esac
