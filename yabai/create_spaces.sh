#!/bin/sh

DESIRED_SPACES_PER_DISPLAY=3
CURRENT_SPACES="$(yabai -m query --displays | jq -r '.[].spaces | @sh')"

DELTA=0
while read -r line
do
  LAST_SPACE="$(echo "${line##* }")"
  LAST_SPACE=$(($LAST_SPACE+$DELTA))
  EXISTING_SPACE_COUNT="$(echo "$line" | wc -w)"
  MISSING_SPACES=$(($DESIRED_SPACES_PER_DISPLAY - $EXISTING_SPACE_COUNT))
  if [ "$MISSING_SPACES" -gt 0 ]; then
    for i in $(seq 1 $MISSING_SPACES)
    do
      yabai -m space --create "$LAST_SPACE"
      LAST_SPACE=$(($LAST_SPACE+1))
    done
  elif [ "$MISSING_SPACES" -lt 0 ]; then
    for i in $(seq 1 $((-$MISSING_SPACES)))
    do
      yabai -m space --destroy "$LAST_SPACE"
      LAST_SPACE=$(($LAST_SPACE-1))
    done
  fi
  DELTA=$(($DELTA+$MISSING_SPACES))
done <<< "$CURRENT_SPACES"


yabai -m space 1 --label note
# open "obsidian://open?vault=personal"
open "obsidian://open?vault=know-how"
yabai -m rule --add app="^Obsidian$" space=note

yabai -m space 2 --label office
yabai -m rule --add app="^Slack$" space=office

yabai -m space 3 --label code
yabai -m rule --add app="^WezTerm$" space=code

# sketchybar --trigger space_change --trigger windows_on_spaces

