#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------------------------------------
#  Script de NiPeGun para actualizar OpenWrt guardando un log del proceso de actualización
#-------------------------------------------------------------------------------------------

## Crear la variable para guardar la fecha y hora en la que se realiza la actualización
   FechaDeEjec=$(date +A%YM%mD%d@%T)

## Crear la carpeta de logs para las actualizaciones
   mkdir -p /root/logs/actualizaciones/

## Actualizar la lista de paquetes disponibles
   opkg update

## Crear un archivo con la lista de los paquetes actualizables
   opkg list-upgradable | cut -f 1 -d ' ' > /var/tmp/OpenWrt-PaquetesActualizables.list

## Transformar ese archivo en un script que actualice todos esos paquetes
   mv /var/tmp/OpenWrt-PaquetesActualizables.list /var/tmp/ActualizarOpenWrt.sh
   chmod +x /var/tmp/ActualizarOpenWrt.sh
   sed -i -e 's/^/opkg update \&\& opkg upgrade /' /var/tmp/ActualizarOpenWrt.sh

## Ejecutar el script de actualización y mandar la salida también a un archivo de log
   /var/tmp/ActualizarOpenWrt.sh 2>&1 | tee /root/logs/actualizaciones/$FechaDeEjec.log
 
## Modificando el archivo de logs para que sea más clara su lectura
   sed -i '/^Downloading/d' /root/logs/actualizaciones/$FechaDeEjec.log
   sed -i '/^Updated/d'     /root/logs/actualizaciones/$FechaDeEjec.log
   sed -i '/^Signature/d'   /root/logs/actualizaciones/$FechaDeEjec.log

