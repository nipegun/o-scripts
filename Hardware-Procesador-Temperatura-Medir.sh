#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para medir la temperatura de la CPU en OpenWrt
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/o-scripts/master/Hardware-Procesador-Temperatura-Medir.sh | sh
# ----------

vTempEntero=$(cat /sys/class/thermal/thermal_zone0/temp)
vTempCelcius=$(($vTempEntero / 1000))

echo $vTempCelcius

