#!/bin/sh

# Script: json-red-agrupado.sh
# Objetivo: leer JSON plano de mapa-de-red.sh y agrupar por interfaz + IP local.
# Compatible con BusyBox /bin/sh (OpenWrt)

vTemp="/tmp/red-mapa.tmp"
vOut="/tmp/red-mapa-out.tmp"
vInput="/tmp/red-input.tmp"
> "$vTemp"
> "$vOut"
> "$vInput"

# Detectar si el script recibe entrada por stdin o un archivo JSON
if [ -t 0 ]; then
  # No hay datos por stdin, comprobar si se pasó archivo como argumento
  if [ -z "$1" ]; then
    echo ""
    echo "Error: este script necesita datos JSON por stdin o un archivo .json como argumento." >&2
    echo "Ejemplo 1: ./ArpSan-CompletoConHostname -json | $0" >&2
    echo "Ejemplo 2: $0 salida.json" >&2
    echo ""
    exit 1
  fi
  if [ ! -f "$1" ]; then
    echo "Error: el archivo '$1' no existe o no es accesible." >&2
    exit 1
  fi
  cat "$1" > "$vInput"
else
  cat /dev/stdin > "$vInput"
fi

# Verificar que el archivo de entrada tiene contenido JSON
if ! grep -q '{' "$vInput"; then
  echo "Error: el archivo o entrada proporcionada no contiene JSON válido." >&2
  exit 1
fi

# Leer la IP local de cada interfaz en formato "interfaz:ip"
ip -4 -o addr show | awk '{print $2 ":" $4}' | while IFS=: read -r vIf vCIDR; do
  vIpLocal="${vCIDR%%/*}"
  echo "$vIf|$vIpLocal" >> "$vTemp"
done

# Leer objetos JSON y extraer campos
grep '{' "$vInput" | while IFS= read -r vLinea; do
  vInterfaz=$(echo "$vLinea" | sed -n 's/.*"interfaz": *"\([^"]*\)".*/\1/p')
  vIp=$(echo "$vLinea" | sed -n 's/.*"ip": *"\([^"]*\)".*/\1/p')
  vMac=$(echo "$vLinea" | sed -n 's/.*"mac": *"\([^"]*\)".*/\1/p')
  vHost=$(echo "$vLinea" | sed -n 's/.*"hostname": *"\([^"]*\)".*/\1/p')
  vVendor=$(echo "$vLinea" | sed -n 's/.*"fabricante": *"\([^"]*\)".*/\1/p')
  echo "$vInterfaz|$vIp|$vMac|$vHost|$vVendor" >> "$vOut"
done

# Construir JSON agrupado
echo "{"
vPrimeraInterfaz="1"

while IFS="|" read -r vInterfaz vIpLocal; do
  vHosts=$(grep "^$vInterfaz|" "$vOut" | sort -t'|' -k2,2V)
  [ -z "$vHosts" ] && continue

  if [ "$vPrimeraInterfaz" = "1" ]; then
    vPrimeraInterfaz="0"
  else
    echo ","
  fi

  printf "  \"%s (%s)\": [\n" "$vInterfaz" "$vIpLocal"

  vPrimeroHost="1"
  echo "$vHosts" | while IFS="|" read -r vIf vIp vMac vHost vVendor; do
    vIpEsc=$(printf '%s' "$vIp" | sed 's/"/\\"/g')
    vMacEsc=$(printf '%s' "$vMac" | sed 's/"/\\"/g')
    vHostEsc=$(printf '%s' "$vHost" | sed 's/"/\\"/g')
    vVendorEsc=$(printf '%s' "$vVendor" | sed 's/"/\\"/g')

    if [ "$vPrimeroHost" = "1" ]; then
      printf "    {\"ip\": \"%s\", \"mac\": \"%s\", \"hostname\": \"%s\", \"fabricante\": \"%s\"}" "$vIpEsc" "$vMacEsc" "$vHostEsc" "$vVendorEsc"
      vPrimeroHost="0"
    else
      printf ",\n    {\"ip\": \"%s\", \"mac\": \"%s\", \"hostname\": \"%s\", \"fabricante\": \"%s\"}" "$vIpEsc" "$vMacEsc" "$vHostEsc" "$vVendorEsc"
    fi
  done

  printf "\n  ]"
done < "$vTemp"

printf "\n}\n"
