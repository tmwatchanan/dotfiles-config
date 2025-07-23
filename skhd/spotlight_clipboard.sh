#!/usr/bin/env sh
# trigger cmd-space then cmd-4 with a slight delay

osascript -e "
tell application \"System Events\"
    delay 0.1
    key code 49 using {command down}      -- ⌘ + Space
    delay 0.1
    key code 21 using {command down}      -- ⌘ + 4
end tell
" > /dev/null 2>&1 &
