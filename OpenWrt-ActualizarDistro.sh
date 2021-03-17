#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------
#  Script de NiPeGun para actualizar la Distro completa
#--------------------------------------------------------

# Actualizar los paquetes instalados
/root/scripts/o-scripts/OpenWrt-Actualizar.sh

# Determinar cual es la última versión de OpenWrt
UltVersOpenWrt=$(curl --silent https://downloads.openwrt.org/releases/ | grep -B 1 faillogs | grep -v faillogs | cut -d '"' -f 4 | sed 's/.$//')

echo ""
echo "La última versión de OpenWrt es: $UltVersOpenWrt"
echo ""

# Actualizar el kernel
#opkg update
#opkg install curl
#mv /boot/vmlinuz /boot/vmlinuz.old
curl -R -o /boot/vmlinuz.nuevo https://downloads.openwrt.org/releases/$UltVersOpenWrt/targets/x86/64/openwrt-$UltVersOpenWrt-x86-64-vmlinuz

