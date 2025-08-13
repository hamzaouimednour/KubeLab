#!/bin/sh
IF="iwm0_wlan0"
CONF="/conf/wpa.conf"

mkdir -p /var/run/wpa_supplicant

pkill dhclient 2>/dev/null
pkill wpa_supplicant 2>/dev/null

ifconfig $IF down
ifconfig $IF up

/usr/sbin/wpa_supplicant -B -i $IF -c $CONF
sleep 5
/sbin/dhclient $IF