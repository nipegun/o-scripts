#!/bin/sh

opkg update
opkg install arp-scan
opkg-install arp-scan-database
mkdir -p /etc/arp-scan
curl -L https://raw.githubusercontent.com/royhills/arp-scan/refs/heads/master/mac-vendor.txt -o /etc/arp-scan/mac-vendor.txt
# Para ejecutar:
#  arp-scan --interface=devbrwan --localnet | grep -v DUP | sort -n
#  arp-scan --interface=devbrlan --localnet | grep -v DUP | sort -n
