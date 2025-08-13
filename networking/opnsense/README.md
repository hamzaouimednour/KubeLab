# TL;DR
- `backups`: folder contains the backups for OPNsense conf (easy to restore using the web UI in case of failure)
- `config`: folder contains OPNsense sys config files and scripts.


# 🛠 Issues

## (1) Keeping OPNsense Wi-Fi Alive (iwm0_wlan0 Auto-Reconnect Fix)
### Problem :
So here's the deal, I end up moving my cluster to the office room because of the space and I set my OPNsense box to connect to my ISP router over Wi-Fi using an Intel card (`iwm0`).
It works great at boot… until the link drops especially on unstable 5 GHz (faster than 2.4 GHz but shorter range and more sensitive to interference) in my house. And when it drops, OPNsense just sits there like, "Oh well, guess I'm offline now."

![LOL](https://media1.tenor.com/m/CLHLWEfIcF0AAAAd/shrug.gif)

### Solution :
Here's the workflow I went with:
- Have a proper WPA (sec protocol to access my wifi with a password) config stored both in `/etc/wpa_supplicant.conf` (for boot) and `/conf/wpa.conf` (for scripts).
- Made a quick reconnect script (`/conf/wlan.sh`) to bring the interface up/down and get a fresh IP.
- Built a watchdog script (`/conf/wlan-watchdog.sh`) that runs every minute via cron:
   - Pings a reliable target (Google DNS `8.8.8.8`)
   - Logs connection details (SSID, IP, status)
   - Runs the reconnect script if the ping fail
   - cron: `* * * * * /conf/wlan-watchdog.sh`
- Updated `/etc/rc.conf` (file specifies which services are enabled during system startup) so the interface is created and managed at boot with `wpa_supplicant`.

### Config files / scripts :
#### `/etc/wpa_supplicant.conf`
Used by the system at boot.
```conf
ctrl_interface=/var/run/wpa_supplicant
network={
    ssid="NET-AFF4"
    psk="N4AREQMR"
    key_mgmt=WPA-PSK
}
```

#### `/conf/wpa.conf`
Used by my reconnect scripts (identical contents).
```conf
ctrl_interface=/var/run/wpa_supplicant
network={
    ssid="NET-AFF4"
    psk="N4AREQMR"
    key_mgmt=WPA-PSK
    priority=10
}
```

#### `/conf/wlan.sh`
This is my "quick reconnect" solution that runs the WPA handshake and grabs a DHCP lease.

```sh
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
```

#### `/conf/wlan-watchdog.sh`
Runs every minute to check connectivity and reconnect if down.

```sh
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

# Keep log file from growing forever (max ~5MB)
[ -f "$LOG" ] && [ $(stat -f%z "$LOG" 2>/dev/null) -gt 5242880 ] \
    && tail -n 2000 "$LOG" > "$LOG.tmp" && mv "$LOG.tmp" "$LOG"
```

#### `/etc/rc.conf`
Tells OPNsense how to create the wireless interface and where the WPA config lives.

```conf
# Keyboard layout
keymap="fr.kbd"

# WLAN config
wlans_iwm0="iwm0_wlan0"
ifconfig_iwm0_wlan0="WPA DHCP"
create_args_iwm0_wlan0="wlanmode sta"
wpa_supplicant_iwm0_wlan0_conf="/etc/wpa_supplicant.conf"
```