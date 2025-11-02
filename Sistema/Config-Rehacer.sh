#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para rehacer la configuración de OpenWrt al estilo nipegun
#
# Ejecución remota:
#   curl -s https://raw.githubusercontent.com/nipegun/o-scripts/master/Config-Rehacer.sh | sh
# ----------

## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
   if [ "$(opkg list-installed | grep wget)" = "" ]; then
     echo ""
     echo "  El paquete wget no está instalado. Iniciando su instalación..."
     echo ""
     opkg update
     opkg install wget
   fi

mv /root/scripts/o-scripts/Recursos/PartExt4/etc/config/adblock  /etc/config/adblock
mv /root/scripts/o-scripts/Recursos/PartExt4/etc/config/dhcp     /PartExt4/etc/config/dhcp
mv /root/scripts/o-scripts/Recursos/PartExt4/etc/config/firewall /PartExt4/etc/config/firewall
mv /root/scripts/o-scripts/Recursos/PartExt4/etc/config/network  /etc/config/network
mv /root/scripts/o-scripts/Recursos/PartExt4/etc/config/wireless /etc/config/wireless

reboot

