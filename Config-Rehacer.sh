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

wget https://raw.githubusercontent.com/nipegun/o-scripts/main/Recursos/PartExt4/etc/config/adblock  -O /etc/config/adblock
wget https://raw.githubusercontent.com/nipegun/o-scripts/main/Recursos/PartExt4/etc/config/dhcp     -O /PartExt4/etc/config/dhcp
wget https://raw.githubusercontent.com/nipegun/o-scripts/main/Recursos/PartExt4/etc/config/firewall -O /PartExt4/etc/config/firewall
wget https://raw.githubusercontent.com/nipegun/o-scripts/main/Recursos/PartExt4/etc/config/network  -O /etc/config/network
wget https://raw.githubusercontent.com/nipegun/o-scripts/main/Recursos/PartExt4/etc/config/wireless -O /etc/config/wireless

reboot

