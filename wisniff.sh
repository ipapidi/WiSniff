#!/bin/bash

# Get interfaces (like wlan0, wlan1)
INTERFACES=$(iw dev | awk '$1=="Interface"{print $2}' | paste -sd "!")
# Get nearby SSIDs
SSIDS=$(nmcli -t -f SSID dev wifi | awk 'NF' | sort -u | paste -sd "!")

# Check monitor mode status
MODE_OUTPUT=$(iwconfig 2>/dev/null | grep "Mode:")
IN_MON_MODE=$(echo "$MODE_OUTPUT" | grep "Monitor")
STATUS_MSG="✅ All interfaces in managed mode."
[ -n "$IN_MON_MODE" ] && STATUS_MSG="⚠️ A device is already in monitor mode!"

# Build form
VALUES=$(yad --form --title="Wi-Fi Sniff Control" --separator="|" \
--field="Wi-Fi SSID:CB" "$SSIDS" \
--field="Wi-Fi Password:H" "" \
--field="Internet Interface:CB" "$INTERFACES" \
--field="Sniffing Interface:CB" "$INTERFACES" \
--field="Status:RO" "$STATUS_MSG" \
--button="Start Sniffing Prep":0 \
--button="Restore Normal Mode":1 \
--button="Exit":2)

RET=$?

SSID=$(echo "$VALUES" | cut -d'|' -f1)
PASS=$(echo "$VALUES" | cut -d'|' -f2)
INTERNET_IFACE=$(echo "$VALUES" | cut -d'|' -f3)
SNIFFER_IFACE=$(echo "$VALUES" | cut -d'|' -f4)

# ---- Start Sniff Mode ----
if [[ $RET -eq 0 ]]; then
(
echo "# Disconnecting $SNIFFER_IFACE..."
nmcli device disconnect "$SNIFFER_IFACE"

echo "# Marking $SNIFFER_IFACE unmanaged..."
echo -e "[keyfile]\nunmanaged-devices=interface-name:$SNIFFER_IFACE" | sudo tee /etc/NetworkManager/conf.d/unmanaged.conf > /dev/null

echo "# Reloading NetworkManager..."
sudo systemctl reload NetworkManager
sleep 2

echo "# Connecting $INTERNET_IFACE to $SSID..."
nmcli device wifi connect "$SSID" ifname "$INTERNET_IFACE" password "$PASS"
sleep 3

echo "# Setting $SNIFFER_IFACE to monitor mode..."
sudo ip link set "$SNIFFER_IFACE" down
sudo iw dev "$SNIFFER_IFACE" set type monitor
sudo ip link set "$SNIFFER_IFACE" up

echo "# ✅ Done! Sniff mode ready."
) | yad --progress --title="Preparing Sniffing Mode" --pulsate --auto-close --no-buttons --width=400

yad --info --title="Ready" --text="✅ Sniffer in monitor mode\n🌐 Internet online"

# ---- Restore Mode ----
elif [[ $RET -eq 1 ]]; then
(
echo "# Switching $SNIFFER_IFACE back to managed mode..."
sudo ip link set "$SNIFFER_IFACE" down
sudo iw dev "$SNIFFER_IFACE" set type managed
sudo ip link set "$SNIFFER_IFACE" up

echo "# Removing unmanaged config..."
sudo rm /etc/NetworkManager/conf.d/unmanaged.conf

echo "# Reloading NetworkManager..."
sudo systemctl reload NetworkManager

echo "# ✅ Restore complete."
) | yad --progress --title="Restoring Interface" --pulsate --auto-close --no-buttons --width=400

yad --info --title="Restored" --text="✅ $SNIFFER_IFACE is back in managed mode."

# ---- Exit ----
else
exit 0
fi
