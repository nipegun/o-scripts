#!/bin/sh

opkg update
opkg install arp-scan
opkg install arp-scan-database
mkdir -p /etc/arp-scan
curl -L https://raw.githubusercontent.com/royhills/arp-scan/refs/heads/master/mac-vendor.txt -o /etc/arp-scan/mac-vendor.txt
# Para ejecutar:
#  arp-scan --interface=devbrwan --localnet | grep -v DUP | grep -v ackets | grep ^[0-9] | sort -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n
#  arp-scan --interface=devbrlan --localnet | grep -v DUP | grep -v ackets | grep ^[0-9] | sort -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n
