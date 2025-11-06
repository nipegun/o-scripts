#!/bin/sh

# Script: mapa-de-red.sh
# Objetivo: listar todos los hosts activos en cada interfaz privada,
#           mostrando IP, MAC, hostname y fabricante.
# Requiere: arp-scan, grep, sort, awk

vModoJSON="no"
[ "$1" = "-json" ] && vModoJSON="si"

if [ "$vModoJSON" = "no" ]; then
  echo "interfaz|ip|mac|hostname|fabricante"
else
  echo "["
fi

vPrimero="si"
vCache="/tmp/mapa-de-red.cache"
> "$vCache"

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

          # Buscar en /tmp/hosts (dnsmasq) si no está
          if [ -z "$vHost" ] || [ "$vHost" = "*" ] || [ "$vHost" = "-" ]; then
            vHost=$(grep -w "$vIP" /tmp/hosts* 2>/dev/null | awk '{print $2}' | head -n1)
          fi

          # Buscar en /etc/hosts si no está
          if [ -z "$vHost" ] || [ "$vHost" = "*" ] || [ "$vHost" = "-" ]; then
            vHost=$(awk -v ip="$vIP" '$1 == ip {print $2}' /etc/hosts 2>/dev/null | head -n1)
          fi

          # Si no hay aún, revisar cache o lanzar nslookup en background
          if [ -z "$vHost" ] || [ "$vHost" = "*" ] || [ "$vHost" = "-" ]; then
            vHost=$(grep "^$vIP|" "$vCache" | cut -d'|' -f2)
            if [ -z "$vHost" ]; then
              (
                vTmp=$(nslookup "$vIP" localhost 2>/dev/null | awk '/name =/ {print $4}' | sed 's/\.$//' )
                [ -z "$vTmp" ] && vTmp="-"
                echo "$vIP|$vTmp" >> "$vCache"
              ) &
              vHost="-"
            fi
          fi

          [ -z "$vHost" ] && vHost="-"

          if [ "$vModoJSON" = "no" ]; then
            echo "$vInterfaz|$vIP|$vMAC|$vHost|$vVendor"
          else
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
