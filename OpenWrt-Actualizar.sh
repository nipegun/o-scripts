#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#---------------------------------------------
#  Script de NiPeGun para actualizar OpenWrt
#---------------------------------------------

FechaDeEjec=$(date +A%YM%mD%d@%T)

mkdir -p /root/logs/actualizaropenwrt/

opkg update
opkg list-upgradable | cut -f 1 -d ' ' | xargs opkg upgrade 2>&1 | tee /root/logs/actualizaropenwrt/$Fecha.log

