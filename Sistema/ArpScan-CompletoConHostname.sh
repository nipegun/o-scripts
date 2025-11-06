#!/bin/sh

# Script de NiPeGun para listar el resultado de un escaneo arp de todas las interfaces del router que tienen asignada una IP. mostrando IP, MAC, hostname (si está en leases o resolvible por DNS local) y fabricante.
#   Compatibilidad: BusyBox /bin/sh (OpenWrt)
#   Paquetes necesarios: arp-scan, grep, sort, awk
#
# Ejecución remota:
#  curl -sLk 

vModoJSON="no"
[ "$1" = "-json" ] && vModoJSON="si"

vCache="/tmp/mapa-de-red.cache"
vTemp="/tmp/mapa-de-red.tmp"
> "$vCache"
> "$vTemp"

# Mostrar cabecera solo en modo texto
if [ "$vModoJSON" = "no" ]; then
  echo "interfaz|ip|mac|hostname|fabricante"
fi

# Recorre interfaces con IP privada
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

          # Buscar en /tmp/hosts (dnsmasq)
          if [ -z "$vHost" ] || [ "$vHost" = "*" ] || [ "$vHost" = "-" ]; then
            vHost=$(grep -w "$vIP" /tmp/hosts* 2>/dev/null | awk '{print $2}' | head -n1)
          fi

          # Buscar en /etc/hosts
          if [ -z "$vHost" ] || [ "$vHost" = "*" ] || [ "$vHost" = "-" ]; then
            vHost=$(awk -v ip="$vIP" '$1 == ip {print $2}' /etc/hosts 2>/dev/null | head -n1)
          fi

          # Si no hay, revisar cache o resolver async
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

            echo "{\"interfaz\": \"$vInterfazEsc\", \"ip\": \"$vIPEsc\", \"mac\": \"$vMACEsc\", \"hostname\": \"$vHostEsc\", \"fabricante\": \"$vVendorEsc\"}" >> "$vTemp"
          fi
        done
    ;;
  esac
done

# Salida JSON válida sin herramientas externas
if [ "$vModoJSON" = "si" ]; then
  echo "["
  vPrimeraLinea="1"
  while IFS= read -r vLinea; do
    if [ "$vPrimeraLinea" = "1" ]; then
      printf "  %s" "$vLinea"
      vPrimeraLinea="0"
    else
      printf ",\n  %s" "$vLinea"
    fi
  done < "$vTemp"
  printf "\n]\n"
fi

