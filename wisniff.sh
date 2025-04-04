#!/bin/bash

# Root Check
if [[ $EUID -ne 0 ]]; then
  yad --info --title="Permission Required" \
  --text="🔐 This script needs root privileges.\n\nPlease enter your password in the terminal."
  exec sudo "$0" "$@"
  exit 0
fi

# Collect Interfaces
INTERFACES=$(iw dev | awk '$1=="Interface"{print $2}' | paste -sd "!")
SSIDS=$(nmcli -t -f SSID dev wifi | awk 'NF' | sort -u | paste -sd "!")

# Detect Mode Status
MODE_OUTPUT=$(iw dev | grep -B1 "type monitor" | grep Interface | awk '{print $2}')
STATUS_MSG="✅ All interfaces in managed mode."
[ -n "$MODE_OUTPUT" ] && STATUS_MSG="⚠️ $MODE_OUTPUT is in monitor mode!"

# YAD
VALUES=$(yad --form --title="WiSniff Control Panel" --separator="|" \
--field="Wi-Fi SSID:CB" "$SSIDS" \
--field="Wi-Fi Password:H" "" \
--field="Internet Interface:CB" "$INTERFACES" \
--field="Sniffing Interface:CB" "$INTERFACES" \
--field="Status:RO" "$STATUS_MSG" \
--button="Start Sniffing Prep":0 \
--button="Exit":1)

RET=$?

# Parse Form Values
SSID=$(echo "$VALUES" | cut -d'|' -f1)
PASS=$(echo "$VALUES" | cut -d'|' -f2)
INTERNET_IFACE=$(echo "$VALUES" | cut -d'|' -f3)
SNIFFER_IFACE=$(echo "$VALUES" | cut -d'|' -f4)

# Sniff Prep
if [[ $RET -eq 0 ]]; then
(
echo "# Disconnecting $SNIFFER_IFACE..."
nmcli device disconnect "$SNIFFER_IFACE"
sleep 1

echo "# Disabling autoconnect on $SNIFFER_IFACE..."
nmcli connection show --active | grep "$SNIFFER_IFACE" | awk '{print $1}' | while read CONN; do
  nmcli connection modify "$CONN" connection.autoconnect no
done

echo "# Switching $SNIFFER_IFACE to monitor mode..."
ip link set "$SNIFFER_IFACE" down
iw dev "$SNIFFER_IFACE" set type monitor
ip link set "$SNIFFER_IFACE" up

# Reconnect internet if not already
nmcli -t -f DEVICE,STATE dev | grep "$INTERNET_IFACE" | grep -q "connected"
if [[ $? -ne 0 ]]; then
  echo "# Connecting $INTERNET_IFACE to $SSID..."
  nmcli device wifi connect "$SSID" ifname "$INTERNET_IFACE" password "$PASS"
else
  echo "# $INTERNET_IFACE already connected."
fi

echo "# ✅ Sniffing interface ready. Internet is online."
) | yad --progress --title="Preparing Monitor Mode" --pulsate --auto-close --no-buttons --width=400

yad --info --title="Sniff Ready" \
--text="✅ $SNIFFER_IFACE is in monitor mode\n🌐 $INTERNET_IFACE is online"

# Exit
else
  exit 0
fi
