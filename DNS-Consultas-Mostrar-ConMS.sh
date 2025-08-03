#!/bin/sh

# Script de NiPeGun para mostrar en tiempo real las consultas DNS recibidas por dnsmasq en OpenWrt con salida coloreada (sin color en la fecha)

# Función para obtener la fecha con milisegundos si es posible
vFechaActual() {
  if [ -x /usr/libexec/date-coreutils ]; then
    /usr/libexec/date-coreutils +"a%Ym%md%d@%H:%M:%S.%3N"
  else
    date +"a%Ym%md%d@%H:%M:%S"
  fi
}

# Colores ANSI
cVerde="\033[0;32m"
cAzul="\033[0;34m"
cAmarillo="\033[1;33m"
cReset="\033[0m"

logread -f | while read -r vLinea; do
  echo "$vLinea" | grep -q "dnsmasq" || continue
  echo "$vLinea" | grep -q "query\[" || continue

  # Extraer dominio e IP
  vDominio=$(echo "$vLinea" | awk '{for(i=1;i<=NF;i++) if($i ~ /query\[.*\]/) print $(i+1)}')
  vIP=$(echo "$vLinea" | awk '{for(i=1;i<=NF;i++) if($i == "from") print $(i+1)}')

  # Filtrar entradas no deseadas
  echo "$vDominio $vIP" | grep -q "127.0.0.1" && continue
  echo "$vDominio" | grep -q "\.in-addr\.arpa$" && continue

  # Obtener hostname desde leases, si no, usar IP como nombre
  vHost=$(grep "$vIP" /tmp/dhcp.leases | awk '{print $4}')
  [ -z "$vHost" ] && vHost="$vIP"

  # Mostrar en terminal con formato y color
  vFecha=$(vFechaActual)
  printf "%s | ${cVerde}%s${cReset} | ${cAzul}%s${cReset} | ${cAmarillo}%s${cReset}\n" "$vFecha" "$vIP" "$vHost" "$vDominio"
done
