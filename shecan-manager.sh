#!/bin/bash

UPDATE_LINK="PASTE_YOUR_UPDATE_LINK_HERE"

# Detect active network interface
IFACE=$(nmcli -t -f DEVICE,STATE d \
    | grep ":connected" \
    | cut -d: -f1 \
    | grep -v "^lo$" \
    | head -n 1 \
    | tr -d ' \t\r\n')

if [ -z "$IFACE" ]; then
  echo "❌ No valid active network interface found!"
  exit 1
fi

echo "Active Interface: $IFACE"
echo ""
echo "1) Enable Shecan DNS"
echo "2) Disable Shecan DNS"
echo "3) Update IP (Premium)"
echo "4) Enable + Update"
read -p "Choose: " choice

case $choice in
  1)
    sudo resolvectl dns "$IFACE" 178.22.122.101 185.51.200.1
    echo "✅ Shecan DNS Enabled"
    ;;

  2)
    sudo resolvectl dns "$IFACE" ""
    sudo resolvectl domain "$IFACE" ""
    echo "♻️ DNS Reset to DHCP"
    ;;

  3)
    curl "$UPDATE_LINK"
    echo "✅ IP Updated on Shecan"
    ;;

  4)
    sudo resolvectl dns "$IFACE" 178.22.122.101 185.51.200.1
    curl "$UPDATE_LINK"
    echo "🚀 Shecan Enabled + IP Updated"
    ;;

  *)
    echo "❌ Invalid option"
    ;;
esac
