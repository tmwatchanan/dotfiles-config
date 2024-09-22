#!/usr/bin/env sh

# The wifi_change event supplies a $INFO variable in which the current SSID
# is passed to the script.
if [ "$SENDER" = "wifi_change" ]; then
    INFO=$(
        system_profiler SPAirPortDataType -detailLevel basic |
        awk '/Current Network Information:/ {
            getline
            if ($0 ~ /^[[:space:]]*$/) {
                next
            }
            gsub(/^[[:space:]]+|:$/, "", $0)
            print $0
            exit
        }'
    )

    if [[ -z "$INFO" ]] || [[ -z "${INFO##You are not*}" ]]; then
        ICON="󰤫"
        WIFI="Not Connected"
    else
        ICON="󰤨"
        WIFI=$(echo $INFO | tr -d '\t')
    fi
    sketchybar --set $NAME label="${WIFI}" icon="${ICON}"
fi
