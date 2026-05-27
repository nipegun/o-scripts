#!/bin/sh

#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/o-scripts/refs/heads/master/Sistema/Hardware-Red-Tarjetas-Mapear.sh | sh
#

for vInterfaz in /sys/class/net/*; do
  vNombre="${vInterfaz##*/}"

  [ "$vNombre" = "lo" ] && continue

  echo "INTERFAZ=$vNombre"
  echo "  MAC=$(cat "/sys/class/net/$vNombre/address" 2>/dev/null)"
  echo "  DEVICE=$(readlink -f "/sys/class/net/$vNombre/device" 2>/dev/null)"

  if [ -e "/sys/class/net/$vNombre/dev_port" ]; then
    echo "  DEV_PORT=$(cat "/sys/class/net/$vNombre/dev_port" 2>/dev/null)"
  else
    echo "  DEV_PORT="
  fi

  if [ -e "/sys/class/net/$vNombre/dev_id" ]; then
    echo "  DEV_ID=$(cat "/sys/class/net/$vNombre/dev_id" 2>/dev/null)"
  else
    echo "  DEV_ID="
  fi

  if [ -e "/sys/class/net/$vNombre/phys_port_name" ]; then
    echo "  PHYS_PORT_NAME=$(cat "/sys/class/net/$vNombre/phys_port_name" 2>/dev/null)"
  else
    echo "  PHYS_PORT_NAME="
  fi

  echo
done
