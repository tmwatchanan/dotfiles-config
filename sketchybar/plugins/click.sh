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

osascript <<EOF
tell application "System Events"
  tell process "$APP"
    set found to false
    repeat with mi in menu bar items of menu bar 1
      # set miDesc to description of mi
      # display dialog "Found menu item: '" & miDesc & "'" buttons {"OK"} default button 1
      try
        if (description of mi) starts with "$DESC" then
          perform action "AXPress" of mi
          set found to true
          exit repeat
        end if
      end try
    end repeat
    # if not found then
    #   display dialog "Menu item with description '$DESC' not found in $APP." buttons {"OK"} default button 1
    # end if
  end tell
end tell
EOF
