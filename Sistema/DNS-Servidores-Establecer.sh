#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para establecer los servidores DNS
#
# Ejecución remota:
#   curl -s https://raw.githubusercontent.com/nipegun/o-scripts/refs/heads/master/Sistema/DNS-Servidores-Establecer.sh | sh
# ----------

## Comprobar si el paquete chattr está instalado. Si no lo está, instalarlo.
   if [ "$(opkg list-installed | grep chattr)" = "" ]; then
     echo ""
     echo "  El paquete chattr no está instalado. Iniciando su instalación..."
     echo ""
     opkg update
     opkg install chattr
   fi

echo ""
echo "  Quitando el atributo ininmutable a /tmp/resolv.conf ..."
echo ""
chattr -i /tmp/resolv.conf

echo ""
echo "  Estableciendo el/los servidor/es DNS..."
echo ""
echo "nameserver 9.9.9.9"  > /etc/resolv.conf
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

echo ""
echo "  Volviendo a agregar el atributo ininmutable a /tmp/resolv.conf ..."
echo ""
chattr +i /tmp/resolv.conf

echo ""
echo "  El contenido final de archivo /etc/resolv.conf es:"
echo ""
cat /etc/resolv.conf
echo ""
