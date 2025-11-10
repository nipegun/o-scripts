#!/bin/sh

# ----------
# Script de NiPeGun para listar el resultado de un escaneo arp de todas las interfaces del router que tienen asignada una IP. mostrando IP, MAC, hostname (si está en leases o resolvible por DNS local) y fabricante.
#   Compatibilidad: BusyBox /bin/sh (OpenWrt)
#   Paquetes necesarios: arp-scan, grep, sort, awk
#
# Ejecución remota:
#  curl -sLk https://raw.githubusercontent.com/nipegun/o-scripts/refs/heads/master/Sistema/ArpScan-CompletoConHostname.sh | sh
#
# Ejecución remota con parámetros:
#   curl -sLk https://raw.githubusercontent.com/nipegun/o-scripts/refs/heads/master/Sistema/ArpScan-CompletoConHostname.sh | sh -s -- -json
#   curl -sLk https://raw.githubusercontent.com/nipegun/o-scripts/refs/heads/master/Sistema/ArpScan-CompletoConHostname.sh | sh -s -- -json | jq .
# ----------

vModoJSON="no"
vInterfacesManual=""

# Parsear argumentos
while [ "$#" -gt 0 ]; do
  case "$1" in
    -json)
      vModoJSON="si"
      ;;
    -i)
      shift
      vInterfacesManual="$1"
      ;;
  esac
  shift
done

vCache="/tmp/mapa-de-red.cache"
vTemp="/tmp/mapa-de-red.tmp"
> "$vCache"
> "$vTemp"

# Mostrar cabecera solo en modo texto
if [ "$vModoJSON" = "no" ]; then
  echo "interfaz|ip|mac|hostname|fabricante"
fi

# Calcular interfaces a usar
if [ -n "$vInterfacesManual" ]; then
  aInterfaces=$(echo "$vInterfacesManual" | tr ',' ' ')
else
  # Obtener interfaces activas con IPv4 (excluyendo loopback)
  aInterfaces=$(ip -4 addr show up | grep -v ' lo:' | awk -F': ' '/^[0-9]+: / {print $2}')
fi

# Recorrer interfaces seleccionadas
for vInterfazRaw in $aInterfaces; do
  # Quitar la parte después de @ si existe (por ejemplo: eth0.10@br-lan -> eth0.10)
  vInterfaz=$(echo "$vInterfazRaw" | cut -d'@' -f1)

  vIPCIDR=$(ip -4 addr show dev "$vInterfaz" 2>/dev/null | awk '/inet / {print $2}' | head -n1)
  [ -z "$vIPCIDR" ] && continue
  vIP=$(echo "$vIPCIDR" | cut -d'/' -f1)

  case "$vIP" in
    10.*|192.168.*|172.1[6-9].*|172.2[0-9].*|172.3[0-1].*)
      /usr/bin/arp-scan -I "$vInterfaz" --localnet 2>/dev/null | \
        grep -v "^Interface:" | \
        grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | \
        sort -t . -k1,1n -k2,2n -k3,3n -k4,4n | \
        while read vIP vMAC vVendor; do
          vHost="-"

          # Buscar en leases
          for vLeaseFile in /tmp/*.leases; do
            [ -f "$vLeaseFile" ] || continue
            vHost=$(awk -v ip="$vIP" '$3 == ip {print $4}' "$vLeaseFile")
            [ -n "$vHost" ] && [ "$vHost" != "*" ] && break
          done

          # Buscar en /tmp/hosts*
          if [ -z "$vHost" ] || [ "$vHost" = "*" ] || [ "$vHost" = "-" ]; then
            vHost=$(grep -w "$vIP" /tmp/hosts* 2>/dev/null | awk '{print $2}' | head -n1)
          fi

          # Buscar en /etc/hosts
          if [ -z "$vHost" ] || [ "$vHost" = "*" ] || [ "$vHost" = "-" ]; then
            vHost=$(awk -v ip="$vIP" '$1 == ip {print $2}' /etc/hosts 2>/dev/null | head -n1)
          fi

          # Revisar cache o resolver async
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
            vInterfazEsc=$(echo "$vInterfaz" | sed 's/"/\\"/g')
            vIPEsc=$(echo "$vIP" | sed 's/"/\\"/g')
            vMACEsc=$(echo "$vMAC" | sed 's/"/\\"/g')
            vHostEsc=$(echo "$vHost" | sed 's/"/\\"/g')
            vVendorEsc=$(echo "$vVendor" | sed 's/"/\\"/g')

            echo "{\"interfaz\": \"$vInterfazEsc\", \"ip\": \"$vIPEsc\", \"mac\": \"$vMACEsc\", \"hostname\": \"$vHostEsc\", \"fabricante\": \"$vVendorEsc\"}" >> "$vTemp"
          fi
        done
    ;;
  esac
done

# Salida JSON
if [ "$vModoJSON" = "si" ]; then
  echo "["
  vPrimeraLinea="1"
  while IFS= read vLinea; do
    if [ "$vPrimeraLinea" = "1" ]; then
      printf "  %s" "$vLinea"
      vPrimeraLinea="0"
    else
      printf ",\n  %s" "$vLinea"
    fi
  done < "$vTemp"
  echo
  echo "]"
fi

