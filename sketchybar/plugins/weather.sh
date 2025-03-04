#!/usr/bin/env zsh

LOCATION_JSON=$(curl -s https://ipinfo.io/json)

# LOCATION="$(echo $LOCATION_JSON | jq '.city' | tr -d '"')"
REGION="$(echo $LOCATION_JSON | jq '.region' | tr -d '"')"
# COUNTRY="$(echo $LOCATION_JSON | jq '.country' | tr -d '"')"

# Line below replaces spaces with +
# LOCATION_ESCAPED="${LOCATION// /+}+${REGION// /+}"
LOCATION_ESCAPED="${REGION// /+}"
WEATHER_JSON=$(curl -s "https://wttr.in/$LOCATION_ESCAPED?format=j2")
# WEATHER_JSON=$(curl -s "https://wttr.in?format=j2")

# Fallback if empty
if [ -z $WEATHER_JSON ]; then

  sketchybar --set $NAME label="no weather info"
  # sketchybar --set $NAME.moon icon=
  
  return
fi

# echo $WEATHER_JSON

LOCATION=$(echo $WEATHER_JSON | jq '.nearest_area[0].areaName[0].value' | tr -d '"')
TEMPERATURE=$(echo $WEATHER_JSON | jq '.current_condition[0].temp_C' | tr -d '"')
WEATHER_DESCRIPTION=$(echo $WEATHER_JSON | jq '.current_condition[0].weatherDesc[0].value' | tr -d '"')
# MOON_PHASE=$(echo $WEATHER_JSON | jq '.weather[0].astronomy[0].moon_phase' | tr -d '"')
#
# case ${MOON_PHASE} in
#   "New Moon")
#     ICON=
#     ;;
#   "Waxing Crescent")
#     ICON=
#     ;;
#   "First Quarter")
#     ICON=
#     ;;
#   "Waxing Gibbous")
#     ICON=
#     ;;
#   "Full Moon")
#     ICON=
#     ;;
#   "Waning Gibbous")
#     ICON=
#     ;;
#   "Last Quarter")
#     ICON=
#     ;;
#   "Waning Crescent")
#     ICON=
#     ;;
# esac

# WEATHER_CODE=$(echo $WEATHER_JSON | jq '.current_condition[0].weatherCode' | tr -d '"')
#
# case $WEATHER_CODE in
#   116) # Partly cloudy
#     WEATHER_ICON=
#     ;;
#   *)
#     WEATHER_ICON=
#     ;;
# esac
#
# echo "WEATHER CODE $WEATHER_CODE"

sketchybar --set $NAME label="$LOCATION  $TEMPERATURE󰔄 $WEATHER_DESCRIPTION"
# sketchybar --set $NAME.moon icon=$ICON
