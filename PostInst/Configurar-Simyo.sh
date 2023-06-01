#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para configurar un router OpenWrt para conectarse a una ONT de Simyo
#
# Ejecución remota:
#   curl -sL x | bash
# ----------

# Definir variables de color
  vColorAzul="\033[0;34m"
  vColorAzulClaro="\033[1;34m"
  vColorVerde='\033[1;32m'
  vColorRojo='\033[1;31m'
  vFinColor='\033[0m'

# /etc/config/network
  echo ""                                                                     > /etc/config/network
  echo "config device"                                                       >> /etc/config/network
  echo "  option name 'br-wan'"                                              >> /etc/config/network
  echo "  option type 'bridge'"                                              >> /etc/config/network
  echo "  list ports 'eth1'"                                                 >> /etc/config/network
  echo "  list ports 'wan'"                                                  >> /etc/config/network
  echo "  option bridge_empty '1'"                                           >> /etc/config/network
  echo ""                                                                    >> /etc/config/network
  echo "config device"                                                       >> /etc/config/network
  echo "  option name 'br-lan'"                                              >> /etc/config/network
  echo "  option type 'bridge'"                                              >> /etc/config/network
  echo "  list ports 'lan1'"                                                 >> /etc/config/network
  echo "  list ports 'lan2'"                                                 >> /etc/config/network
  echo "  list ports 'lan3'"                                                 >> /etc/config/network
  echo "  list ports 'lan4'"                                                 >> /etc/config/network
  echo "  list ports 'sfp2'"                                                 >> /etc/config/network
  echo "  option bridge_empty '1'"                                           >> /etc/config/network
  echo ""                                                                    >> /etc/config/network
  echo "config device"                                                       >> /etc/config/network
  echo "  option name 'br-iot'"                                              >> /etc/config/network
  echo "  option type 'bridge'"                                              >> /etc/config/network
  echo "  option bridge_empty '1'"                                           >> /etc/config/network
  echo ""                                                                    >> /etc/config/network
  echo "config device"                                                       >> /etc/config/network
  echo "  option name 'br-inv'"                                              >> /etc/config/network
  echo "  option type 'bridge'"                                              >> /etc/config/network
  echo "  option bridge_empty '1'"                                           >> /etc/config/network
  echo ""                                                                    >> /etc/config/network
  echo "config interface 'loopback'"                                         >> /etc/config/network
  echo "  option device 'lo'"                                                >> /etc/config/network
  echo "  option proto 'static'"                                             >> /etc/config/network
  echo "  option ipaddr '127.0.0.1'"                                         >> /etc/config/network
  echo "  option netmask '255.0.0.0'"                                        >> /etc/config/network
  echo ""                                                                    >> /etc/config/network
  echo "config interface 'wan'"                                              >> /etc/config/network
  echo "  option device 'br-wan.832'"                                        >> /etc/config/network
  echo "  option proto 'dhcp'"                                               >> /etc/config/network
  echo "  option hostname '*'"                                               >> /etc/config/network
  echo "  option delegate '0'"                                               >> /etc/config/network
  echo "  option peerdns '0'"                                                >> /etc/config/network
  echo "  list dns '9.9.9.9'"                                                >> /etc/config/network
  echo "  list dns '149.112.112.112'"                                        >> /etc/config/network
  echo ""                                                                    >> /etc/config/network
  echo "config interface 'lan'"                                              >> /etc/config/network
  echo "  option device 'br-lan'"                                            >> /etc/config/network
  echo "  option proto 'static'"                                             >> /etc/config/network
  echo "  option ipaddr '192.168.1.1'"                                       >> /etc/config/network
  echo "  option netmask '255.255.255.0'"                                    >> /etc/config/network
  echo "  option delegate '0'"                                               >> /etc/config/network
  echo "  list dns '192.168.1.1'"                                            >> /etc/config/network
  echo ""                                                                    >> /etc/config/network
  echo "config interface 'iot'"                                              >> /etc/config/network
  echo "  option proto 'static'"                                             >> /etc/config/network
  echo "  option ipaddr '192.168.2.1'"                                       >> /etc/config/network
  echo "  option netmask '255.255.255.0'"                                    >> /etc/config/network
  echo "  option device 'br-iot'"                                            >> /etc/config/network
  echo "  list dns '192.168.2.1'"                                            >> /etc/config/network
  echo "  option delegate '0'"                                               >> /etc/config/network
  echo ""                                                                    >> /etc/config/network
  echo "config interface 'inv'"                                              >> /etc/config/network
  echo "  option proto 'static'"                                             >> /etc/config/network
  echo "  option ipaddr '192.168.3.1'"                                       >> /etc/config/network
  echo "  option netmask '255.255.255.0'"                                    >> /etc/config/network
  echo "  option device 'br-inv'"                                            >> /etc/config/network
  echo "  list dns '192.168.3.1'"                                            >> /etc/config/network
  echo "  option delegate '0'"                                               >> /etc/config/network
  echo ""                                                                    >> /etc/config/network
  echo "config interface 'vpn'"                                              >> /etc/config/network
  echo "  option proto 'wireguard'"                                          >> /etc/config/network
  echo "  option private_key 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx='" >> /etc/config/network
  echo "  option listen_port '51820'"                                        >> /etc/config/network
  echo "  list addresses '192.168.255.1/24'"                                 >> /etc/config/network
  echo "  option force_link '1'"                                             >> /etc/config/network
  echo "  option delegate '0'"                                               >> /etc/config/network
  echo "  list dns '192.168.255.1'"                                          >> /etc/config/network

# /etc/config/firewall
