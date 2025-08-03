#!/bin/sh

# Script de NiPeGun para parsear hacia un archivo todas las consultas DNS que recibe dnsmasq, siempre que se haya activado "Registrar consultas" en el menú "Red" >> "DHCP y DNS" >> Pestaña "Registro"
#   Esta versión del script NO registra las consultas con milisegundos

vArchivoLog="/overlay/dns_queries.log"

# Detectar si estamos en foreground (TTY) o background (sin terminal) para ver si sólo guardamos las consultas en el archivo o también las mostramos por terminal 
vModoInteractivo=0
[ -t 1 ] && vModoInteractivo=1

logread -f | while read -r vLinea; do
  echo "$vLinea" | grep -q "dnsmasq" || continue
  echo "$vLinea" | grep -q "query\[" || continue

  vDominio=$(echo "$vLinea" | awk '{for(i=1;i<=NF;i++) if($i ~ /query\[/) print $(i+1)}')
  vIP=$(echo "$vLinea" | awk '{for(i=1;i<=NF;i++) if($i == "from") print $(i+1)}')

  echo "$vDominio $vIP" | grep -q "127.0.0.1" && continue
  echo "$vDominio" | grep -q "\.in-addr\.arpa$" && continue

  vHost=$(grep "$vIP" /tmp/dhcp.leases | awk '{print $4}')
  [ -z "$vHost" ] && vHost="$vIP"

  vFecha=$(date +"a%Ym%md%d@%H:%M:%S")
  vLineaFinal="$vFecha - $vIP - $vHost - $vDominio"

  # Mostrar por pantalla si estamos en modo interactivo
  [ "$vModoInteractivo" -eq 1 ] && echo "$vLineaFinal"

  # Guardar en el archivo
  echo "$vLineaFinal" >> "$vArchivoLog"
done
