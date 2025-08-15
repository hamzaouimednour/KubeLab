#!/bin/sh
IF="iwm0_wlan0"
CONF="/conf/wpa.conf"
TARGET="8.8.8.8"
LOG="/var/log/wlan-watchdog.log"
NOW=$(date '+%Y-%m-%d %H:%M:%S')

SSID=$(ifconfig $IF 2>/dev/null | awk "/ssid /{print \$2}")
IPV4=$(ifconfig $IF 2>/dev/null | awk "/ inet /{print \$2}")
STATUS=$(ifconfig $IF 2>/dev/null | awk "/status:/{print \$2}")

if ping -c1 -t2 $TARGET >/dev/null 2>&1; then
    echo "$NOW | OK   | ssid=$SSID status=$STATUS ip=$IPV4" >> "$LOG"
else
    echo "$NOW | DOWN | ssid=$SSID status=$STATUS ip=$IPV4 | Reconnecting..." >> "$LOG"
        /conf/wlan.sh
fi

# Keep log small
[ -f "$LOG" ] && [ $(stat -f%z "$LOG" 2>/dev/null) -gt 5242880 ] && tail -n 2000 "$LOG" > "$LOG.tmp" && mv "$LOG.tmp" "$LOG"

