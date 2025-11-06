#!/bin/sh

# Script: mapa-de-red.sh
# Objetivo: listar todos los hosts activos en cada interfaz privada,
#           mostrando IP, MAC, hostname (si está en leases o resolvible por DNS local) y fabricante.
# Requiere: arp-scan, grep, sort, awk, nslookup

vModoJSON="no"
[ "$1" = "-json" ] && vModoJSON="si"

if [ "$vModoJSON" = "no" ]; then
  echo "interfaz|ip|mac|hostname|fabricante"
else
  echo "["
fi

vPrimero="si"

ip -4 -o addr show | awk '{print $2 ":" $4}' | while IFS=: read -r vInterfaz vIPCIDR; do
  vIP="${vIPCIDR%%/*}"

  case "$vIP" in
    10.*|192.168.*|172.1[6-9].*|172.2[0-9].*|172.3[0-1].*)
      arp-scan -I "$vInterfaz" --localnet 2>/dev/null | \
        grep -v "^Interface:" | \
        grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | \
        sort -t . -k1,1n -k2,2n -k3,3n -k4,4n | \
        while read -r vIP vMAC vVendor; do
          vHost="-"

          # Buscar en todos los archivos de leases
          for vLeaseFile in /tmp/*.leases; do
            [ -f "$vLeaseFile" ] || continue
            vHost=$(awk -v ip="$vIP" '$3 == ip {print $4}' "$vLeaseFile")
            [ -n "$vHost" ] && [ "$vHost" != "*" ] && break
          done

          # Si no hay lease con nombre, intentar resolver vía DNS local
          if [ -z "$vHost" ] || [ "$vHost" = "*" ] || [ "$vHost" = "-" ]; then
            vHost=$(nslookup "$vIP" localhost 2>/dev/null | awk '/name =/ {print $4}' | sed 's/\.$//' )
          fi

          [ -z "$vHost" ] && vHost="-"

          if [ "$vModoJSON" = "no" ]; then
            echo "$vInterfaz|$vIP|$vMAC|$vHost|$vVendor"
          else
            # Escapar comillas para JSON
            vInterfazEsc=$(printf '%s' "$vInterfaz" | sed 's/"/\\"/g')
            vIPEsc=$(printf '%s' "$vIP" | sed 's/"/\\"/g')
            vMACEsc=$(printf '%s' "$vMAC" | sed 's/"/\\"/g')
            vHostEsc=$(printf '%s' "$vHost" | sed 's/"/\\"/g')
            vVendorEsc=$(printf '%s' "$vVendor" | sed 's/"/\\"/g')

            [ "$vPrimero" = "no" ] && echo ","
            vPrimero="no"

            echo "  {\"interfaz\": \"$vInterfazEsc\", \"ip\": \"$vIPEsc\", \"mac\": \"$vMACEsc\", \"hostname\": \"$vHostEsc\", \"fabricante\": \"$vVendorEsc\"}"
          fi
        done
    ;;
  esac
done

[ "$vModoJSON" = "si" ] && echo "]"
