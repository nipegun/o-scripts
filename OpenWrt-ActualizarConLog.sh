#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------------------------------------
#  Script de NiPeGun para actualizar OpenWrt guardando un log del proceso de actualización
#-------------------------------------------------------------------------------------------

FechaDeEjec=$(date +A%YM%mD%d@%T)

# Crear la carpeta de logs para las actualizaciones
mkdir -p /root/logs/actualizaciones/

# Actualizar la lista de paquetes disponibles
opkg update

# Crear un archivo con la lista de los paquetes actualizables
opkg list-upgradable | cut -f 1 -d ' ' > /tmp/OpenWrt-PaquetesActualizables.list

# Transformar ese archivo en un ejecutable que actualize todos esos paquetes
chmod +x

# Ejecutar la actualización
/tmp/ActualizarOpenWrt.sh 2>&1 | tee /root/logs/actualizaciones/$FechaDeEjec.log


 
