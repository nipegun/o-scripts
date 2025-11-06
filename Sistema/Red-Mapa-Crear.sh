#!/bin/sh
# Script: mapa-de-red.sh
# Objetivo: listar todos los hosts activos en cada interfaz privada,
#           mostrando IP, MAC, hostname (si está en leases o resolvible por DNS local) y fabricante.
# Requiere: arp-scan, grep, sort, awk

LEASES_FILE="/tmp/dhcp.leases"

echo "interfaz|ip|mac|hostname|fabricante"

ip -4 -o addr show | awk '{print $2 ":" $4}' | while IFS=: read -r vInterfaz vIPCIDR; do
  vIP="${vIPCIDR%%/*}"

  case "$vIP" in
    10.*|192.168.*|172.1[6-9].*|172.2[0-9].*|172.3[0-1].*)
      arp-scan -I "$vInterfaz" --localnet 2>/dev/null | \
        grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | \
        sort -t . -k1,1n -k2,2n -k3,3n -k4,4n | \
        while read -r vIP vMAC vVendor; do
          vHost="-"

          # Buscar en los leases de dnsmasq
          if [ -f "$LEASES_FILE" ]; then
            vHost=$(awk -v ip="$vIP" '$3 == ip {print $4}' "$LEASES_FILE")
          fi

          # Si no hay lease con nombre, intentar resolver vía dnsmasq
          if [ -z "$vHost" ] || [ "$vHost" = "*" ] || [ "$vHost" = "-" ]; then
            vHost=$(nslookup "$vIP" localhost 2>/dev/null | awk '/name =/ {print $4}' | sed 's/\.$//' )
          fi

          [ -z "$vHost" ] && vHost="-"
          echo "$vInterfaz|$vIP|$vMAC|$vHost|$vVendor"
        done
    ;;
  esac
done
