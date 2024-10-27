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
yabai -m rule --add app="^Arc$" title="^Work$" space=work

yabai -m space 2 --label office
yabai -m rule --add app="^Arc$" title="^Personal$" space=personal

yabai -m space 3 --label code
yabai -m rule --add app="^WezTerm$" space=code

yabai -m space 4 --label note
# open "obsidian://open?vault=personal"
open "obsidian://open?vault=know-how"
yabai -m rule --add app="^Obsidian$" space=note

# sketchybar --trigger space_change --trigger windows_on_spaces

yabai -m space 6 --label slack
yabai -m rule --add app="^Slack$" space=slack


# Exclude problematic apps from being managed:
yabai -m rule --add label="About This Mac" app="System Information" title="About This Mac" manage=off
# yabai -m rule --add label="Finder" app="^Finder$" title="(Co(py|nnect)|Move|Info|Pref)" manage=off
# yabai -m rule --add label="Safari" app="^Safari$" title="^(General|(Tab|Password|Website|Extension)s|AutoFill|Se(arch|curity)|Privacy|Advance)$" manage=off
# yabai -m rule --add label="Select file to save to" app="^Inkscape$" title="Select file to save to" manage=off
yabai -m rule --add app="^(Calculator|Software Update|System Settings|System Information|zoom.us|Archive Utility|App Store|Activity Monitor|Spotify|Numi|Finder|KiCad|LINE)$" manage=off
yabai -m rule --add label="Safari" app="^Safari$" title="^(General|(Tab|Password|Website|Extension)s|AutoFill|Se(arch|curity)|Privacy|Advance)$" manage=off
yabai -m rule --add label="Arc Settings" app="^Arc$" title="^Mie$" manage=off
yabai -m rule --add label="Arc PiP" app="^Arc$" subrole="^AXSystemDialog$" manage=off
