#!/usr/bin/env bash

location_json=$(curl -s https://ipinfo.io/json)
location=$(echo $location_json | jq -r '.loc')
latitude=$(echo $location | cut -d',' -f1)
longitude=$(echo $location | cut -d',' -f2)
LIMIT_KM=5
aqi_json=$(curl -s "https://www-old.cmuccdc.org/api2/dustboy/near/$latitude/$longitude/$LIMIT_KM")
first_station_data=$(echo $aqi_json | jq '.[0]')

pm25=$(echo $first_station_data | jq -r '.pm25_us_aqi' || echo "-")

color=$(echo $first_station_data | jq -r '.us_color' || echo "255,255,255")
IFS=',' read -r red green blue <<< $(echo "$color" | tr -d '[:space:]')
icon_color=$(printf "0x%02X%02X%02X%02X" 255 "$red" "$green" "$blue")

sketchybar --set $NAME label="$pm25" icon.color=${icon_color}
