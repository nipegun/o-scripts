#!/bin/sh
# Script: mapa-de-red.sh
# Objetivo: listar todos los hosts activos por cada interfaz con IP privada asignada, ordenando las IPs de forma ascendente y mostrando salida parseable.
# Requiere: arp-scan, iproute2, awk, grep, sort, host (opcionalmente avahi-resolve o dig)

# Encabezado CSV parseable
echo "interfaz|ip|mac|hostname|fabricante"

# Detectar interfaces con IP privada asignada
ip -4 -o addr show | awk '{print $2 ":" $4}' | while IFS=: read -r vInterfaz vIPCIDR; do
  vIP="${vIPCIDR%%/*}"

  # Filtrar IPs privadas (RFC1918)
  case "$vIP" in
    10.*|192.168.*|172.1[6-9].*|172.2[0-9].*|172.3[0-1].*)
      arp-scan -I "$vInterfaz" --localnet 2>/dev/null | \
        grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | \
        sort -t . -k1,1n -k2,2n -k3,3n -k4,4n | \
        while read -r vIP vMAC vVendor; do
          # Resolver nombre del host
          vHost=$(host "$vIP" 2>/dev/null | awk '/domain name pointer/ {print $5}' | sed 's/\.$//')
          [ -z "$vHost" ] && vHost="-"
          echo "$vInterfaz|$vIP|$vMAC|$vHost|$vVendor"
        done
    ;;
  esac
done
