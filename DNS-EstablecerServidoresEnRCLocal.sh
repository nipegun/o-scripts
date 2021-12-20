#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#---------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para establecer los servidores DNS post arranque en rc.local
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/o-scripts/master/DNS-EstablecerServidoresEnRCLocal.sh | sh
#
#---------------------------------------------------------------------------------------------------------------


sed -i -e 's|exit 0|echo "nameserver 1.1.1.1" > /etc/resolv.conf\nexit 0|g' /etc/rc.local

