#!/bin/sh /etc/rc.common

# Script de NiPeGun para renombrar tarjetas de red por su conexión física
# Uso:
#  - Copiar dentro de /etc/init.d/
#  - Darle permisos de ejecución
#  - Editar las constantes usando la información sacada de la ejecución de este script:
#    curl -sL https://raw.githubusercontent.com/nipegun/o-scripts/refs/heads/master/Sistema/Hardware-Red-Tarjetas-Mapear.sh | sh
#  - Activarlo en initd:
#    /etc/init.d/Hardware-Red-Tarjetas-Eth-Renombrar-PorMAC.sh enable
#
#   Para que sobreviva a sysupgrade
#     grep -qxF /etc/init.d/Hardware-Red-Tarjetas-Eth-Renombrar-PorMAC.sh /etc/sysupgrade.conf || echo /etc/init.d/Hardware-Red-Tarjetas-Eth-Renombrar-PorMAC.sh >> /etc/sysupgrade.conf
#

START=05

cTmpPrefix='tmp_ren_'

cMacEth0='aa:aa:aa:aa:aa:00'
cMacEth1='aa:aa:aa:aa:aa:01'
cMacEth2='aa:aa:aa:aa:aa:02'
cMacEth3='aa:aa:aa:aa:aa:03'
cMacEth4='aa:aa:aa:aa:aa:04'
cMacEth5='aa:aa:aa:aa:aa:05'
cMacEth6='aa:aa:aa:aa:aa:06'
cMacEth7='aa:aa:aa:aa:aa:07'
cMacEth8='aa:aa:aa:aa:aa:08'

fLog() {
  logger -t fijar-nombres-red "$1"
}

fExisteDispositivo() {
  local vDispositivo

  vDispositivo="$1"

  [ -e "/sys/class/net/$vDispositivo" ]
}

fBuscarDispositivoPorMac() {
  local vMacBuscada
  local vRuta
  local vMacActual
  local vDispositivo

  vMacBuscada="$1"

  for vRuta in /sys/class/net/*/address; do
    [ -e "$vRuta" ] || continue

    vDispositivo="${vRuta%/address}"
    vDispositivo="${vDispositivo##*/}"

    [ "$vDispositivo" = "lo" ] && continue

    vMacActual="$(cat "$vRuta")"

    if [ "$vMacActual" = "$vMacBuscada" ]; then
      echo "$vDispositivo"
      return 0
    fi
  done

  return 1
}

fBajarDispositivo() {
  local vDispositivo

  vDispositivo="$1"

  ip link set dev "$vDispositivo" down 2>/dev/null
}

fRenombrarATemporal() {
  local vMac
  local vNombreFinal
  local vNombreTemporal
  local vDispositivo
  local vMacTemporal

  vMac="$1"
  vNombreFinal="$2"
  vNombreTemporal="${cTmpPrefix}${vNombreFinal}"

  [ -n "$vMac" ] || {
    fLog "MAC vacía para $vNombreFinal"
    return 1
  }

  vDispositivo="$(fBuscarDispositivoPorMac "$vMac")"

  [ -n "$vDispositivo" ] || {
    fLog "No se encontró ningún dispositivo con MAC $vMac para $vNombreFinal"
    return 1
  }

  [ "$vDispositivo" = "$vNombreTemporal" ] && return 0

  if fExisteDispositivo "$vNombreTemporal"; then
    vMacTemporal="$(cat "/sys/class/net/$vNombreTemporal/address")"

    if [ "$vMacTemporal" = "$vMac" ]; then
      return 0
    fi

    fLog "El nombre temporal $vNombreTemporal ya existe y no pertenece a $vMac"
    return 1
  fi

  fBajarDispositivo "$vDispositivo"

  ip link set dev "$vDispositivo" name "$vNombreTemporal" || {
    fLog "No se pudo renombrar $vDispositivo a $vNombreTemporal"
    return 1
  }

  fLog "Renombrado temporal: $vDispositivo -> $vNombreTemporal"
  return 0
}

fRenombrarAFinal() {
  local vNombreFinal
  local vNombreTemporal

  vNombreFinal="$1"
  vNombreTemporal="${cTmpPrefix}${vNombreFinal}"

  fExisteDispositivo "$vNombreTemporal" || {
    fLog "No existe $vNombreTemporal para renombrarlo a $vNombreFinal"
    return 1
  }

  if fExisteDispositivo "$vNombreFinal"; then
    fLog "No se puede crear $vNombreFinal porque ya existe"
    return 1
  fi

  fBajarDispositivo "$vNombreTemporal"

  ip link set dev "$vNombreTemporal" name "$vNombreFinal" || {
    fLog "No se pudo renombrar $vNombreTemporal a $vNombreFinal"
    return 1
  }

  fLog "Renombrado final: $vNombreTemporal -> $vNombreFinal"
  return 0
}

start() {
  fLog "Iniciando renombrado persistente de interfaces"

  fRenombrarATemporal "$cMacEth0" "eth0"
  fRenombrarATemporal "$cMacEth1" "eth1"
  fRenombrarATemporal "$cMacEth2" "eth2"
  fRenombrarATemporal "$cMacEth3" "eth3"
  fRenombrarATemporal "$cMacEth4" "eth4"
  fRenombrarATemporal "$cMacEth5" "eth5"
  fRenombrarATemporal "$cMacEth6" "eth6"
  fRenombrarATemporal "$cMacEth7" "eth7"
  fRenombrarATemporal "$cMacEth8" "eth8"

  fRenombrarAFinal "eth0"
  fRenombrarAFinal "eth1"
  fRenombrarAFinal "eth2"
  fRenombrarAFinal "eth3"
  fRenombrarAFinal "eth4"
  fRenombrarAFinal "eth5"
  fRenombrarAFinal "eth6"
  fRenombrarAFinal "eth7"
  fRenombrarAFinal "eth8"

  fLog "Renombrado persistente terminado"
}
