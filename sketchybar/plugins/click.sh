#!/bin/bash
# This script takes two parameters:
#   $1: application name (e.g., "Control Center")
#   $2: the description to match for the menu bar item
#
# Example usage:
#   ./click.sh "Control Center" "Clock"
#
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <application> <description>"
    exit 1
fi

APP="$1"
DESC="$2"

osascript -e "
tell application \"System Events\"
  with timeout of 2 seconds
    try
      repeat with mi in (menu bar items of menu bar 1 of process \"$APP\")
        try
          if (description of mi) contains \"$DESC\" or (title of mi) contains \"$DESC\" then
            click mi
            exit repeat
          end if
        end try
      end repeat
    end try
  end timeout
end tell
" > /dev/null 2>&1 &
