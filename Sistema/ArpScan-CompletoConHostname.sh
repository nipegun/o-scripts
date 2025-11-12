#!/bin/sh

# ----------
# Script de NiPeGun para listar el resultado de un escaneo arp de todas las interfaces del router que tienen asignada una IP.
#
# Ejecución remota:
#   curl -sL | sh
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
vArchivoMACs="/root/MACsRealesDelCliente.txt"
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
  aInterfaces=$(ip -4 addr show up | grep -v ' lo:' | awk -F': ' '/^[0-9]+: / {print $2}')
fi

# Recorrer interfaces seleccionadas
for vInterfazRaw in $aInterfaces; do
  vInterfaz=$(echo "$vInterfazRaw" | cut -d'@' -f1)
  vIPCIDR=$(ip -4 addr show dev "$vInterfaz" 2>/dev/null | awk '/inet / {print $2}' | head -n1)
  [ -z "$vIPCIDR" ] && continue
  vIP=$(echo "$vIPCIDR" | cut -d'/' -f1)

  case "$vIP" in
    10.*|192.168.*|172.1[6-9].*|172.2[0-9].*|172.3[0-1].*)
      /usr/bin/arp-scan -I "$vInterfaz" --localnet 2>/dev/null | \
        awk '!seen[$1]++' | grep -v "^Interface:" | \
        grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | \
        sort -t . -k1,1n -k2,2n -k3,3n -k4,4n | \
        while read vIP vMAC vVendor; do
          vHost="-"
          vMACLower=$(echo "$vMAC" | tr '[:upper:]' '[:lower:]')

          # ----- PRIORIDAD 1: /root/MACsRealesDelCliente.txt -----
          if [ -r "$vArchivoMACs" ]; then
            vHostManual=$(grep -i "^$vMACLower[[:space:]]*-" "$vArchivoMACs" | head -n1 | awk -F'-' '{print $2}' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
            if [ -n "$vHostManual" ]; then
              vHost="$vHostManual"
            fi
          fi

          # Si no está en MACs reales, buscar en otras fuentes
          if [ "$vHost" = "-" ] || [ -z "$vHost" ]; then
            for vLeaseFile in /tmp/*.leases; do
              [ -f "$vLeaseFile" ] || continue
              vHostTmp=$(awk -v ip="$vIP" '$3 == ip {print $4}' "$vLeaseFile")
              if [ -n "$vHostTmp" ] && [ "$vHostTmp" != "*" ]; then
                vHost="$vHostTmp"
                break
              fi
            done
          fi

          if [ "$vHost" = "-" ] || [ -z "$vHost" ]; then
            vHostTmp=$(grep -w "$vIP" /tmp/hosts* 2>/dev/null | awk '{print $2}' | head -n1)
            [ -n "$vHostTmp" ] && vHost="$vHostTmp"
          fi

          if [ "$vHost" = "-" ] || [ -z "$vHost" ]; then
            vHostTmp=$(awk -v ip="$vIP" '$1 == ip {print $2}' /etc/hosts 2>/dev/null | head -n1)
            [ -n "$vHostTmp" ] && vHost="$vHostTmp"
          fi

          if [ "$vHost" = "-" ] || [ -z "$vHost" ]; then
            vHostTmp=$(grep "^$vIP|" "$vCache" 2>/dev/null | cut -d'|' -f2)
            if [ -n "$vHostTmp" ]; then
              vHost="$vHostTmp"
            else
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
