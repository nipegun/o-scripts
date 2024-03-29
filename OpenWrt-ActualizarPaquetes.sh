#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para actualizar OpenWrt
#
# Basado en la forma oficial de actualizarlo desde la línea de comandos:
#
#   opkg update
#   opkg list-upgradable | cut -f 1 -d ' ' | xargs opkg upgrade
# ----------

vColorAzul="\033[0;34m"
vColorAzulClaro="\033[1;34m"
vColorVerde='\033[1;32m'
vColorRojo='\033[1;31m'
vFinColor='\033[0m'

# Notificar inicio de ejecución del script
  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de actualización de paquetes...${vFinColor}"
  echo ""

# Actualizar la lista de paquetes disponibles
  opkg update

# Crear un archivo con la lista de los paquetes actualizables
  opkg list-upgradable 2> /dev/null | cut -f 1 -d ' ' | sort > /var/tmp/OpenWrt-PaquetesActualizables.list

# Transformar ese archivo en un script que actualice todos esos paquetes
  mv /var/tmp/OpenWrt-PaquetesActualizables.list /var/tmp/ActualizarOpenWrt.sh
  chmod +x /var/tmp/ActualizarOpenWrt.sh
  sed -i -e 's/^/opkg update \&\& opkg upgrade /' /var/tmp/ActualizarOpenWrt.sh

# Ejecutar el script de actualización recién creado
  /var/tmp/ActualizarOpenWrt.sh

# Notificar fin de ejecución del script
  echo ""
  echo -e "${vColorVerde}  Script de actualización de paquetes, finalizado.${vFinColor}"
  echo ""

