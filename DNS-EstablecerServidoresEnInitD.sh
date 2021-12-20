#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#---------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para establecer los servidores DNS post arranque en rc.local
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/o-scripts/master/DNS-EstablecerServidoresEnInitD | sh
#
#---------------------------------------------------------------------------------------------------------

echo ""
echo "  Creando el script en init.d..."
echo ""
echo '#!/bin/sh /etc/rc.common'                      > /etc/init.d/EstablecerServidoresDNS
echo ""                                             >> /etc/init.d/EstablecerServidoresDNS
echo "START=99"                                     >> /etc/init.d/EstablecerServidoresDNS
echo "STOP=15"                                      >> /etc/init.d/EstablecerServidoresDNS
echo ""                                             >> /etc/init.d/EstablecerServidoresDNS
echo "boot() {"                                     >> /etc/init.d/EstablecerServidoresDNS
echo "  echo boot"                                  >> /etc/init.d/EstablecerServidoresDNS
echo '  echo nameserver 1.1.1.1 > /etc/resolv.conf' >> /etc/init.d/EstablecerServidoresDNS
echo "}"                                            >> /etc/init.d/EstablecerServidoresDNS
echo "start() {"                                    >> /etc/init.d/EstablecerServidoresDNS
echo "  echo start"                                 >> /etc/init.d/EstablecerServidoresDNS
echo '  echo nameserver 1.1.1.1 > /etc/resolv.conf' >> /etc/init.d/EstablecerServidoresDNS
echo "}"                                            >> /etc/init.d/EstablecerServidoresDNS  
echo ""                                             >> /etc/init.d/EstablecerServidoresDNS
echo "stop() {"                                     >> /etc/init.d/EstablecerServidoresDNS
echo "  echo stop"                                  >> /etc/init.d/EstablecerServidoresDNS
echo "  # Comandos para parar la aplicación"        >> /etc/init.d/EstablecerServidoresDNS
echo "}"                                            >> /etc/init.d/EstablecerServidoresDNS
chmod +x                                               /etc/init.d/EstablecerServidoresDNS

echo ""
echo "  Activando el script en init.d..."
echo ""
/etc/init.d/EstablecerServidoresDNS enable

echo ""
echo "  Comprobando si se creó el enlace..."
echo ""
ls -lh /etc/rc.d | grep EstablecerServidoresDNS

echo ""
echo "  Creando la tarea cron..."
echo ""
touch /etc/crontabs/root
echo '* * * * * echo "nameserver 1.1.1.1" > /etc/resolv.conf' >> /etc/crontabs/root
/etc/init.d/cron restart

