#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------------------------------------------------
#  Script de NiPeGun para hacer copia de seguridad interna de los archivos importantes de OpenWrt
#--------------------------------------------------------------------------------------------------

# Crear la variable para guardar la fecha y hora en la que se realiza la actualización
FechaDeEjec=$(date +A%YM%mD%d@%T)

# Crear la carpeta de copias de Seguridad
mkdir -p /CopSegInterna/$FechaDeEjec/ > /dev/null

# Copia de la configuración general
mkdir -p /CopSegInterna/$FechaDeEjec/etc/config/
cp /etc/config/*  /CopSegInterna/$FechaDeEjec/etc/config/

# Copia de AdBlock
mkdir -p /CopSegInterna/$FechaDeEjec/etc/adblock/
cp /etc/adblock/adblock.blacklist  /CopSegInterna/$FechaDeEjec/etc/adblock/
cp /etc/adblock/adblock.whitelist  /CopSegInterna/$FechaDeEjec/etc/adblock/

