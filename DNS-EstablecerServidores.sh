#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------
#  Script de NiPeGun para establecer los servidores DNS
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/o-scripts/master/DNS-EstablecerServidores.sh | sh
#
#---------------------------------------------------------

echo ""
echo "  Quitando el atributo ininmutable a /etc/resolv.conf ..."
echo ""
chattr -i /etc/resolv.conf

echo ""
echo "  Estableciendo el/los servidor/es DNS..."
echo ""
echo "nameserver 1.1.1.1" > /etc/resolv.conf

echo ""
echo "  Volviendo a agregar el atributo ininmutable a /etc/resolv.conf ..."
echo ""
chattr +i /etc/resolv.conf

echo ""
echo "  El contenido final de archivo /etc/resolv.conf es:"
echo ""
cat /etc/resolv.conf

