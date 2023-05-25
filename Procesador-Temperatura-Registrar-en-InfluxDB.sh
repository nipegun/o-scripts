#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para registrar la temperatura del procesador de OpenWrt en una base de datos InfluxDB
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/o-scripts/master/Procesador-Temperatura-Registrar-en-InfluxDB.sh | sh
# ----------

vHostInflux="192.168.1.99"
vPuertoInflux="8086"

# ---------- No tocar a partir de aquí ----------
vBaseDeDatos="hardware"
vHost=$(uci get system.@system[0].hostname)
vSensor="procesador"
vTemperatura=$(/root/scripts/o-scripts/Procesador-Temperatura-Medir.sh)
vFecha=$(awk 'BEGIN { srand(); print strftime("%s")""int(rand()*1000000000) }')

curl -XPOST http://$vHostInflux:$vPuertoInflux/write?db=$vBaseDeDatos --data-binary "$vHost,sensor=$vSensor temperatura=$vTemperatura $vFecha"

