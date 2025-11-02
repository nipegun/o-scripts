#!/bin/sh

# Script de NiPeGun para mostrar en tiempo real las consultas DNS recibidas por dnsmasq en OpenWrt con salida coloreada
# siempre que se haya activado "Registrar consultas" en el menú "Red" >> "DHCP y DNS" >> Pestaña "Registro"
#
#   Esta versión del script muestra las consultas con milisegundos por eso tiene estos requisitos:
#     opkg update
#     opkg install coreutils-date
#

# Función para obtener la fecha con milisegundos si está disponible
vFechaActual() {
  if [ -x /usr/libexec/date-coreutils ]; then
    /usr/libexec/date-coreutils +"a%Ym%md%d@%H:%M:%S.%3N"
  else
    date +"a%Ym%md%d@%H:%M:%S"
  fi
}

# Colores ANSI
cRojo="\033[0;31m"
cAzul="\033[0;34m"
cVerde="\033[0;32m"
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

  # Obtener hostname desde leases, o usar IP si no hay
  vHost=$(grep "$vIP" /tmp/dhcp.leases | awk '{print $4}')
  [ -z "$vHost" ] && vHost="$vIP"

  # Mostrar línea coloreada
  vFecha=$(vFechaActual)
  printf "%s | ${cRojo}%s${cReset} | ${cAzul}%s${cReset} | ${cVerde}%s${cReset}\n" "$vFecha" "$vIP" "$vHost" "$vDominio"
done

