#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------
#  Script de NiPeGun para actualizar la Distro completa
#--------------------------------------------------------

# Actualizar los paquetes ya instalados
/root/scripts/o-scripts/OpenWrt-Actualizar.sh

# Determinar cual es la última versión de OpenWrt
UltVersOpenWrt=$(curl --silent https://downloads.openwrt.org/releases/ | grep -B 1 faillogs | grep -v faillogs | cut -d '"' -f 4 | sed 's/.$//')

# Actualizar el kernel a la última versión
opkg update
opkg install curl
mv /boot/vmlinuz /boot/vmlinuz.old
curl --silent -R -o /boot/vmlinuz https://downloads.openwrt.org/releases/$UltVersOpenWrt/targets/x86/64/openwrt-$UltVersOpenWrt-x86-64-vmlinuz

# Descargar el paquete del kernel
PaqueteKernel=$(curl --silent https://downloads.openwrt.org/releases/$UltVersOpenWrt/targets/x86/64/packages/ | grep kernel | cut -d '"' -f 4)
mkdir -p /root/paquetes/kernel/ 2> /dev/null
cd /root/paquetes/kernel/
curl --silent -R -O https://downloads.openwrt.org/releases/$UltVersOpenWrt/targets/x86/64/packages/$PaqueteKernel
opkg install /root/paquetes/kernel/$PaqueteKernel

# Determinar la versión instalada de la distro
VersInsalada=$(cat  /etc/opkg/distfeeds.conf | grep base | cut -d '/' -f 6)

# Cambiar repos a la última versión
sed -i.1 's/$VersInsalada/$UltVersOpenWrt/g' /etc/opkg/distfeeds.conf
opkg update

# Actualizar el paquete base-files
  # Quitar el permiso de ejecución al scripts de funciones para que el script de base-files no pueda ejecutarlo
  chmod -x /lib/functions.sh
  opkg upgrade base-files

# Volver a indicar el servidor DNS
echo "nameserver 127.0.0.1" > /etc/resolv.conf

# Volver a ejecutar el script de actualización de paquetes para que se actualicen todos a la última versión
/root/scripts/o-scripts/OpenWrt-Actualizar.sh

