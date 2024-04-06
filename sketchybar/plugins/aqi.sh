#!/usr/bin/env bash

location_json=$(curl -s https://ipinfo.io/json)
location=$(echo $location_json | jq -r '.loc')
latitude=$(echo $location | cut -d',' -f1)
longitude=$(echo $location | cut -d',' -f2)
LIMIT_KM=2
aqi_json=$(curl -s "https://www-old.cmuccdc.org/api2/dustboy/near/$latitude/$longitude/$limit_km")
first_station_data=$(echo $aqi_json | jq '.[0]')

pm25=$(echo $first_station_data | jq -r '.pm25_us_aqi' || echo "-")

color=$(echo $first_station_data | jq -r '.us_color' || echo "255,255,255")
IFS=',' read -ra rgb <<< "$color"
red=$(printf "%02X" "${rgb[0]}")
green=$(printf "%02X" "${rgb[1]}")
blue=$(printf "%02X" "${rgb[2]}")
icon_color="0xff$red$green$blue"

sketchybar --set $NAME label="$pm25" icon.color=${icon_color}
