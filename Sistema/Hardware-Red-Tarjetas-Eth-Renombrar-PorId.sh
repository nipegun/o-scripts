#!/bin/sh /etc/rc.common

# Script de NiPeGun para renombrar tarjetas de red por su conexión física
# Uso:
#  - Copiar dentro de /etc/init.d/
#  - Darle permisos de ejecución
#  - Editar las constantes usando la información sacada de la ejecución de este script:
#    curl -sL https://raw.githubusercontent.com/nipegun/o-scripts/refs/heads/master/Sistema/Hardware-Red-Tarjetas-Mapear.sh | sh | grep -E 'INTERFAZ|DEVICE'
#  - Activarlo en initd:
#    /etc/init.d/Hardware-Red-Tarjetas-Eth-Renombrar-PorId.sh enable
#
#   Para que sobreviva a sysupgrade
#     grep -qxF /etc/init.d/Hardware-Red-Tarjetas-Eth-Renombrar-PorId.sh /etc/sysupgrade.conf || echo /etc/init.d/Hardware-Red-Tarjetas-Eth-Renombrar-PorId.sh >> /etc/sysupgrade.conf
#

START=05

cTmpPrefix='tmp_ren_'

cIdEth0='0000:03:00.0|0'
cIdEth1='0000:03:00.0|1'
cIdEth2='0000:04:00.0|0'
cIdEth3='0000:04:00.1|0'
cIdEth4='0000:05:00.0|0'
cIdEth5='0000:06:00.0|0'
cIdEth6='0000:07:00.0|0'
cIdEth7='0000:08:00.0|0'
cIdEth8='0000:09:00.0|0'

fLog() {
  logger -t fijar-nombres-red "$1"
}

fExisteDispositivo() {
  local vDispositivo

  vDispositivo="$1"

  [ -e "/sys/class/net/$vDispositivo" ]
}

fObtenerPci() {
  local vDispositivo
  local vRuta
  local vPci

  vDispositivo="$1"

  vRuta="$(readlink -f "/sys/class/net/$vDispositivo/device" 2>/dev/null)"
  vPci="${vRuta##*/}"

  echo "$vPci"
}

fObtenerDevPort() {
  local vDispositivo

  vDispositivo="$1"

  if [ -e "/sys/class/net/$vDispositivo/dev_port" ]; then
    cat "/sys/class/net/$vDispositivo/dev_port"
  else
    echo "0"
  fi
}

fObtenerIdFisico() {
  local vDispositivo
  local vPci
  local vDevPort

  vDispositivo="$1"

  vPci="$(fObtenerPci "$vDispositivo")"
  vDevPort="$(fObtenerDevPort "$vDispositivo")"

  echo "$vPci|$vDevPort"
}

fBuscarDispositivoPorIdFisico() {
  local vIdBuscado
  local vRuta
  local vDispositivo
  local vIdActual

  vIdBuscado="$1"

  for vRuta in /sys/class/net/*; do
    [ -e "$vRuta" ] || continue

    vDispositivo="${vRuta##*/}"

    [ "$vDispositivo" = "lo" ] && continue

    vIdActual="$(fObtenerIdFisico "$vDispositivo")"

    if [ "$vIdActual" = "$vIdBuscado" ]; then
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
  local vIdFisico
  local vNombreFinal
  local vNombreTemporal
  local vDispositivo
  local vIdTemporal

  vIdFisico="$1"
  vNombreFinal="$2"
  vNombreTemporal="${cTmpPrefix}${vNombreFinal}"

  [ -n "$vIdFisico" ] || {
    fLog "ID físico vacío para $vNombreFinal"
    return 1
  }

  vDispositivo="$(fBuscarDispositivoPorIdFisico "$vIdFisico")"

  [ -n "$vDispositivo" ] || {
    fLog "No se encontró ningún dispositivo con ID físico $vIdFisico para $vNombreFinal"
    return 1
  }

  [ "$vDispositivo" = "$vNombreTemporal" ] && return 0

  if fExisteDispositivo "$vNombreTemporal"; then
    vIdTemporal="$(fObtenerIdFisico "$vNombreTemporal")"

    if [ "$vIdTemporal" = "$vIdFisico" ]; then
      return 0
    fi

    fLog "El temporal $vNombreTemporal ya existe y no pertenece a $vIdFisico"
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
  fLog "Iniciando renombrado persistente por ID físico"

  fRenombrarATemporal "$cIdEth0" "eth0"
  fRenombrarATemporal "$cIdEth1" "eth1"
  fRenombrarATemporal "$cIdEth2" "eth2"
  fRenombrarATemporal "$cIdEth3" "eth3"
  fRenombrarATemporal "$cIdEth4" "eth4"
  fRenombrarATemporal "$cIdEth5" "eth5"
  fRenombrarATemporal "$cIdEth6" "eth6"
  fRenombrarATemporal "$cIdEth7" "eth7"
  fRenombrarATemporal "$cIdEth8" "eth8"

  fRenombrarAFinal "eth0"
  fRenombrarAFinal "eth1"
  fRenombrarAFinal "eth2"
  fRenombrarAFinal "eth3"
  fRenombrarAFinal "eth4"
  fRenombrarAFinal "eth5"
  fRenombrarAFinal "eth6"
  fRenombrarAFinal "eth7"
  fRenombrarAFinal "eth8"

  fLog "Renombrado persistente por ID físico terminado"
}
