#!/bin/sh

# Script de NiPeGun para parsear hacia un archivo todas las consultas DNS que recibe dnsmasq, siempre que se haya activado "Registrar consultas" en el menú "Red" >> "DHCP y DNS" >> Pestaña "Registro"
#   Esta versión del script registra las consultas con milisegundos
#
# Requisitos:
#   opkg update
#   opkg install coreutils-date
#

vArchivoLog="/root/dns_queries.log"

# Detectar si estamos en foreground (TTY) o background (sin terminal) para ver si sólo guardamos las consultas en el archivo o también las mostramos por terminal 
vModoInteractivo=0
[ -t 1 ] && vModoInteractivo=1

# Función para obtener la fecha con milisegundos si es posible
vFechaActual() {
  if [ -x /usr/libexec/date-coreutils ]; then
    /usr/libexec/date-coreutils +"a%Ym%md%d@%H:%M:%S.%3N"
  else
    date +"a%Ym%md%d@%H:%M:%S"
  fi
}

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

  # Construir línea
  vFecha=$(vFechaActual)
  vLineaFinal="$vFecha - $vIP $vHost $vDominio"

  # Mostrar en terminal si está en foreground
  [ "$vModoInteractivo" -eq 1 ] && echo "$vLineaFinal"

  # Guardar en log persistente
  echo "$vLineaFinal" >> "$vArchivoLog"
done
