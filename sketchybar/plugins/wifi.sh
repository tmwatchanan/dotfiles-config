#!/usr/bin/env sh

# The wifi_change event supplies a $INFO variable in which the current SSID
# is passed to the script.
if [ "$SENDER" = "wifi_change" ]; then
    airport_info=$(/usr/sbin/system_profiler SPAirPortDataType)
    INFO=$(echo "$airport_info" | awk '/Current Network Information:/{f=1; next} f && /^[[:space:]]*[A-Za-z0-9\-_]+:/{print $1; exit}' | sed 's/://')
    if [[ -z "$INFO" ]] || [[ -z "${INFO##You are not*}" ]]; then
        ICON="󰤫"
        WIFI="Not Connected"
    else
        ICON="󰤨"
        WIFI=$(echo $INFO | tr -d '\t')
    fi
    sketchybar --set $NAME label="${WIFI}" icon="${ICON}"
fi
