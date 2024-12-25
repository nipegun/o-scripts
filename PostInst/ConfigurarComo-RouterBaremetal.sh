#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para configurar OpenWrt como router baremetal
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/o-scripts/master/PostInst/ConfigurarComo-RouterBaremetal.sh | sh
# ----------

# Definir variables de color
  vColorAzul="\033[0;34m"
  vColorAzulClaro="\033[1;34m"
  vColorVerde='\033[1;32m'
  vColorRojo='\033[1;31m'
  vFinColor='\033[0m'

# Notificar inicio de ejecución del script
  echo ""
  echo -e "${vColorAzulClaro}  Configurando OpenWrt como router baremetal...${vFinColor}"
  echo ""

# /etc/config/network
  echo ""                                                                     > /etc/config/network
  echo "config interface 'loopback'"                                         >> /etc/config/network
  echo "  option device 'lo'"                                                >> /etc/config/network
  echo "  option proto 'static'"                                             >> /etc/config/network
  echo "  option ipaddr '127.0.0.1'"                                         >> /etc/config/network
  echo "  option netmask '255.0.0.0'"                                        >> /etc/config/network
  echo ""                                                                    >> /etc/config/network

  echo "# WAN directa a eth0, IP por DHCP"                                   >> /etc/config/network
  echo "config interface 'intwan'"                                           >> /etc/config/network
  echo "  option ifname 'eth0'"                                              >> /etc/config/network
  echo "  option proto 'dhcp'"                                               >> /etc/config/network
  echo "  option hostname '*'"                                               >> /etc/config/network
  echo "  option peerdns '0'"                                                >> /etc/config/network
  echo "  option delegate '0'"                                               >> /etc/config/network
  echo "  list dns '9.9.9.9'"                                                >> /etc/config/network
  echo "  list dns '149.112.112.112'"                                        >> /etc/config/network
  echo ""                                                                    >> /etc/config/network
  
  echo "# WAN en puente, IP por DHCP"                                        >> /etc/config/network
  echo "config device"                                                       >> /etc/config/network
  echo "  option name 'devbrwan'"                                            >> /etc/config/network
  echo "  option type 'bridge'"                                              >> /etc/config/network
  echo "  option bridge_empty '1'"                                           >> /etc/config/network
  echo "  list ports 'eth0'"                                                 >> /etc/config/network
  echo ""                                                                    >> /etc/config/network
  echo "config interface 'intwan'"                                           >> /etc/config/network
  echo "  option device 'devbrwan'"                                          >> /etc/config/network
  echo "  option proto 'dhcp'"                                               >> /etc/config/network
  echo "  option hostname '*'"                                               >> /etc/config/network
  echo "  option peerdns '0'"                                                >> /etc/config/network
  echo "  option delegate '0'"                                               >> /etc/config/network
  echo "  list dns '9.9.9.9'"                                                >> /etc/config/network
  echo "  list dns '149.112.112.112'"                                        >> /etc/config/network

  echo ""                                                                    >> /etc/config/network
  echo "config device"                                                       >> /etc/config/network
  echo "  option name 'devbrlan'"                                            >> /etc/config/network
  echo "  option type 'bridge'"                                              >> /etc/config/network
  echo "  option bridge_empty '1'"                                           >> /etc/config/network
  echo "  list ports 'eth1'"                                                 >> /etc/config/network
  echo "  list ports 'eth2'"                                                 >> /etc/config/network
  echo "  list ports 'eth3'"                                                 >> /etc/config/network
  echo "  list ports 'eth4'"                                                 >> /etc/config/network
  echo ""                                                                    >> /etc/config/network
  echo "config interface 'intlan'"                                           >> /etc/config/network
  echo "  option device 'devbrlan'"                                          >> /etc/config/network
  echo "  option proto 'static'"                                             >> /etc/config/network
  echo "  option ipaddr '192.168.1.1'"                                       >> /etc/config/network
  echo "  option netmask '255.255.255.0'"                                    >> /etc/config/network
  echo "  option delegate '0'"                                               >> /etc/config/network
  echo ""                                                                    >> /etc/config/network

  echo "config device"                                                       >> /etc/config/network
  echo "  option name 'devbriot'"                                            >> /etc/config/network
  echo "  option type 'bridge'"                                              >> /etc/config/network
  echo "  option bridge_empty '1'"                                           >> /etc/config/network
  echo ""                                                                    >> /etc/config/network
  echo "config interface 'intiot'"                                           >> /etc/config/network
  echo "  option device 'devbriot'"                                          >> /etc/config/network
  echo "  option proto 'static'"                                             >> /etc/config/network
  echo "  option ipaddr '192.168.2.1'"                                       >> /etc/config/network
  echo "  option netmask '255.255.255.0'"                                    >> /etc/config/network
  echo "  option delegate '0'"                                               >> /etc/config/network
  echo ""                                                                    >> /etc/config/network

  echo "config device"                                                       >> /etc/config/network
  echo "  option name 'devbrinv'"                                            >> /etc/config/network
  echo "  option type 'bridge'"                                              >> /etc/config/network
  echo "  option bridge_empty '1'"                                           >> /etc/config/network
  echo ""                                                                    >> /etc/config/network
  echo "config interface 'intinv'"                                           >> /etc/config/network
  echo "  option device 'devbrinv'"                                          >> /etc/config/network
  echo "  option proto 'static'"                                             >> /etc/config/network
  echo "  option ipaddr '192.168.3.1'"                                       >> /etc/config/network
  echo "  option netmask '255.255.255.0'"                                    >> /etc/config/network
  echo "  option delegate '0'"                                               >> /etc/config/network
  echo ""                                                                    >> /etc/config/network

  echo "config interface 'intvpn'"                                           >> /etc/config/network
  echo "  option proto 'wireguard'"                                          >> /etc/config/network
  echo "  option private_key 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx='" >> /etc/config/network
  echo "  option listen_port '51820'"                                        >> /etc/config/network
  echo "  list addresses '192.168.255.1/24'"                                 >> /etc/config/network
  echo "  option force_link '1'"                                             >> /etc/config/network
  echo "  option delegate '0'"                                               >> /etc/config/network

# /etc/config/firewall
  echo ""                                 > /etc/config/firewall
  echo "config defaults"                 >> /etc/config/firewall
  echo "  option input 'DROP'"           >> /etc/config/firewall
  echo "  option output 'DROP'"          >> /etc/config/firewall
  echo "  option forward 'DROP'"         >> /etc/config/firewall
  echo "  option synflood_protect '1'"   >> /etc/config/firewall
  echo "  option drop_invalid '1'"       >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall

  echo "config zone"                     >> /etc/config/firewall
  echo "  option name 'zonawan'"         >> /etc/config/firewall
  echo "  list network 'intwan'"         >> /etc/config/firewall
  echo "  list network 'intwan6'"        >> /etc/config/firewall
  echo "  option input 'DROP'"           >> /etc/config/firewall
  echo "  option output 'ACCEPT'"        >> /etc/config/firewall
  echo "  option forward 'DROP'"         >> /etc/config/firewall
  echo "  option masq '1'"               >> /etc/config/firewall
  echo "  option mtu_fix '1'"            >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall

  echo "config zone"                     >> /etc/config/firewall
  echo "  option name 'zonalan'"         >> /etc/config/firewall
  echo "  list network 'intlan'"         >> /etc/config/firewall
  echo "  option input 'ACCEPT'"         >> /etc/config/firewall
  echo "  option output 'ACCEPT'"        >> /etc/config/firewall
  echo "  option forward 'ACCEPT'"       >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall

  echo "config zone"                     >> /etc/config/firewall
  echo "  option name 'zonaiot'"         >> /etc/config/firewall
  echo "  list network 'intiot'"         >> /etc/config/firewall
  echo "  option input 'DROP'"           >> /etc/config/firewall
  echo "  option output 'ACCEPT'"        >> /etc/config/firewall
  echo "  option forward 'DROP'"         >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall

  echo "config zone"                     >> /etc/config/firewall
  echo "  option name 'zonainv'"         >> /etc/config/firewall
  echo "  list network 'intinv'"         >> /etc/config/firewall
  echo "  option input 'DROP'"           >> /etc/config/firewall
  echo "  option output 'ACCEPT'"        >> /etc/config/firewall
  echo "  option forward 'DROP'"         >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall

  echo "config zone"                     >> /etc/config/firewall
  echo "  option name 'zonavpn'"         >> /etc/config/firewall
  echo "  list network 'intvpn'"         >> /etc/config/firewall
  echo "  option input 'ACCEPT'"         >> /etc/config/firewall
  echo "  option output 'ACCEPT'"        >> /etc/config/firewall
  echo "  option forward 'ACCEPT'"       >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall

  echo "config rule"                     >> /etc/config/firewall
  echo "  option name 'wan in DHCP'"     >> /etc/config/firewall
  echo "  option src 'zonawan'"          >> /etc/config/firewall
  echo "  option proto 'udp'"            >> /etc/config/firewall
  echo "  option dest_port '68'"         >> /etc/config/firewall
  echo "  option target 'ACCEPT'"        >> /etc/config/firewall
  echo "  option family 'ipv4'"          >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall

  echo "config rule"                     >> /etc/config/firewall
  echo "  option name 'wan in PING'"     >> /etc/config/firewall
  echo "  option src 'zonawan'"          >> /etc/config/firewall
  echo "  option proto 'icmp'"           >> /etc/config/firewall
  echo "  option family 'ipv4'"          >> /etc/config/firewall
  echo "  option target 'ACCEPT'"        >> /etc/config/firewall
  echo "  list icmp_type 'echo-request'" >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config rule"                     >> /etc/config/firewall
  echo "  option name 'wan in WG'"       >> /etc/config/firewall
  echo "  option src 'zonawan'"          >> /etc/config/firewall
  echo "  option proto 'udp'"            >> /etc/config/firewall
  echo "  option dest_port '51820'"      >> /etc/config/firewall
  echo "  option target 'ACCEPT'"        >> /etc/config/firewall
  echo "  option family 'ipv4'"          >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config forwarding"               >> /etc/config/firewall
  echo "  option src 'zonalan'"          >> /etc/config/firewall
  echo "  option dest 'zonawan'"         >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config forwarding"               >> /etc/config/firewall
  echo "  option src 'zonalan'"          >> /etc/config/firewall
  echo "  option dest 'zonaiot'"         >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config forwarding"               >> /etc/config/firewall
  echo "  option src 'zonalan'"          >> /etc/config/firewall
  echo "  option dest 'zonainv'"         >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config forwarding"               >> /etc/config/firewall
  echo "  option src 'zonalan'"          >> /etc/config/firewall
  echo "  option dest 'zonavpn'"         >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config forwarding"               >> /etc/config/firewall
  echo "  option src 'zonaiot'"          >> /etc/config/firewall
  echo "  option dest 'zonawan'"         >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config forwarding"               >> /etc/config/firewall
  echo "  option src 'zonainv'"          >> /etc/config/firewall
  echo "  option dest 'zonawan'"         >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config forwarding"               >> /etc/config/firewall
  echo "  option src 'zonavpn'"          >> /etc/config/firewall
  echo "  option dest 'zonawan'"         >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config forwarding"               >> /etc/config/firewall
  echo "  option src 'zonavpn'"          >> /etc/config/firewall
  echo "  option dest 'zonalan'"         >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config forwarding"               >> /etc/config/firewall
  echo "  option src 'zonavpn'"          >> /etc/config/firewall
  echo "  option dest 'zonaiot'"         >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config forwarding"               >> /etc/config/firewall
  echo "  option src 'zonavpn'"          >> /etc/config/firewall
  echo "  option dest 'zonainv'"         >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config rule"                     >> /etc/config/firewall
  echo "  option name 'iot in DHCP'"     >> /etc/config/firewall
  echo "  list proto 'udp'"              >> /etc/config/firewall
  echo "  option src 'zonaiot'"          >> /etc/config/firewall
  echo "  option dest_port '67 68'"      >> /etc/config/firewall
  echo "  option target 'ACCEPT'"        >> /etc/config/firewall
  echo "  option family 'ipv4'"          >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config rule"                     >> /etc/config/firewall
  echo "  option name 'iot in DNS'"      >> /etc/config/firewall
  echo "  list proto 'udp'"              >> /etc/config/firewall
  echo "  option src 'zonaiot'"          >> /etc/config/firewall
  echo "  option dest_port '53'"         >> /etc/config/firewall
  echo "  option target 'ACCEPT'"        >> /etc/config/firewall
  echo "  option family 'ipv4'"          >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config rule"                     >> /etc/config/firewall
  echo "  option name 'inv in DHCP'"     >> /etc/config/firewall
  echo "  list proto 'udp'"              >> /etc/config/firewall
  echo "  option src 'zonainv'"          >> /etc/config/firewall
  echo "  option dest_port '67 68'"      >> /etc/config/firewall
  echo "  option target 'ACCEPT'"        >> /etc/config/firewall
  echo "  option family 'ipv4'"          >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config rule"                     >> /etc/config/firewall
  echo "  option name 'inv in DNS'"      >> /etc/config/firewall
  echo "  option src 'zonainv'"          >> /etc/config/firewall
  echo "  option dest_port '53'"         >> /etc/config/firewall
  echo "  option target 'ACCEPT'"        >> /etc/config/firewall
  echo "  list proto 'udp'"              >> /etc/config/firewall
  echo "  option family 'ipv4'"          >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall

# /etc/config/dhcp
  echo ""                                                      > /etc/config/dhcp
  echo "config dnsmasq"                                       >> /etc/config/dhcp
  echo "  option domainneeded '1'"                            >> /etc/config/dhcp
  echo "  option localise_queries '1'"                        >> /etc/config/dhcp
  echo "  option rebind_protection '1'"                       >> /etc/config/dhcp
  echo "  option rebind_localhost '1'"                        >> /etc/config/dhcp
  echo "  option local '/lan/'"                               >> /etc/config/dhcp
  echo "  option domain 'lan'"                                >> /etc/config/dhcp
  echo "  option expandhosts '1'"                             >> /etc/config/dhcp
  echo "  option cachesize '1000'"                            >> /etc/config/dhcp
  echo "  option authoritative '1'"                           >> /etc/config/dhcp
  echo "  option readethers '1'"                              >> /etc/config/dhcp
  echo "  option leasefile '/tmp/dhcp.leases'"                >> /etc/config/dhcp
  echo "  option localservice '1'"                            >> /etc/config/dhcp
  echo "  option ednspacket_max '1232'"                       >> /etc/config/dhcp
  echo "  option doh_backup_noresolv '-1'"                    >> /etc/config/dhcp
  echo "  option noresolv '1'"                                >> /etc/config/dhcp
  echo "  list doh_backup_server ''"                          >> /etc/config/dhcp
  echo "  list doh_backup_server '/mask.icloud.com/'"         >> /etc/config/dhcp
  echo "  list doh_backup_server '/mask-h2.icloud.com/'"      >> /etc/config/dhcp
  echo "  list doh_backup_server '/use-application-dns.net/'" >> /etc/config/dhcp  
  echo "  list doh_backup_server '127.0.0.1#5053'"            >> /etc/config/dhcp
  echo "  list doh_backup_server '127.0.0.1#5054'"            >> /etc/config/dhcp
  echo "  list server '/mask.icloud.com/'"                    >> /etc/config/dhcp
  echo "  list server '/mask-h2.icloud.com/'"                 >> /etc/config/dhcp
  echo "  list server '/use-application-dns.net/'"            >> /etc/config/dhcp
  echo "  list server '127.0.0.1#5053'"                       >> /etc/config/dhcp
  echo "  list server '127.0.0.1#5054'"                       >> /etc/config/dhcp
  echo "  option confdir '/tmp/dnsmasq.d'"                    >> /etc/config/dhcp
  echo ""                                                     >> /etc/config/dhcp
  echo "config odhcpd 'odhcpd'"                               >> /etc/config/dhcp
  echo "  option maindhcp '0'"                                >> /etc/config/dhcp
  echo "  option leasefile '/tmp/hosts/odhcpd'"               >> /etc/config/dhcp
  echo "  option leasetrigger '/usr/sbin/odhcpd-update'"      >> /etc/config/dhcp
  echo "  option loglevel '4'"                                >> /etc/config/dhcp
  echo ""                                                     >> /etc/config/dhcp
  echo "config dhcp 'intwan_dns'"                             >> /etc/config/dhcp
  echo "  option interface 'intwan'"                          >> /etc/config/dhcp
  echo "  option ignore '1'"                                  >> /etc/config/dhcp
  echo ""                                                     >> /etc/config/dhcp
  echo "config dhcp 'intlan_dns'"                             >> /etc/config/dhcp
  echo "  option interface 'intlan'"                          >> /etc/config/dhcp
  echo "  option start '100'"                                 >> /etc/config/dhcp
  echo "  option limit '99'"                                  >> /etc/config/dhcp
  echo "  option leasetime '12h'"                             >> /etc/config/dhcp
  echo "  option dhcpv4 'server'"                             >> /etc/config/dhcp
  echo "  option force '1'"                                   >> /etc/config/dhcp
  echo ""                                                     >> /etc/config/dhcp
  echo "config dhcp 'intiot_dns'"                             >> /etc/config/dhcp
  echo "  option interface 'intiot'"                          >> /etc/config/dhcp
  echo "  option start '100'"                                 >> /etc/config/dhcp
  echo "  option limit '99'"                                  >> /etc/config/dhcp
  echo "  option leasetime '12h'"                             >> /etc/config/dhcp
  echo "  option force '1'"                                   >> /etc/config/dhcp
  echo ""                                                     >> /etc/config/dhcp
  echo "config dhcp 'intinv_dns'"                             >> /etc/config/dhcp
  echo "  option interface 'intinv'"                          >> /etc/config/dhcp
  echo "  option start '100'"                                 >> /etc/config/dhcp
  echo "  option limit '99'"                                  >> /etc/config/dhcp
  echo "  option leasetime '12h'"                             >> /etc/config/dhcp
  echo "  option force '1'"                                   >> /etc/config/dhcp
  echo ""                                                     >> /etc/config/dhcp
  echo "config host"                                          >> /etc/config/dhcp
  echo "  option name 'hostlan-servidor'"                     >> /etc/config/dhcp
  echo "  option dns '1'"                                     >> /etc/config/dhcp
  echo "  option mac '00:00:aa:aa:aa:aa'"                     >> /etc/config/dhcp
  echo "  option ip '192.168.1.10'"                           >> /etc/config/dhcp
  echo ""                                                     >> /etc/config/dhcp
  echo "config host"                                          >> /etc/config/dhcp
  echo "  option name 'hostiot-ledsala'"                      >> /etc/config/dhcp
  echo "  option dns '1'"                                     >> /etc/config/dhcp
  echo "  option mac '00:00:bb:bb:bb:bb'"                     >> /etc/config/dhcp
  echo "  option ip '192.168.2.10'"                           >> /etc/config/dhcp
  echo ""                                                     >> /etc/config/dhcp
  echo "config host"                                          >> /etc/config/dhcp
  echo "  option name 'hostinv-vecino'"                       >> /etc/config/dhcp
  echo "  option dns '1'"                                     >> /etc/config/dhcp
  echo "  option mac '00:00:cc:cc:cc:cc'"                     >> /etc/config/dhcp
  echo "  option ip '192.168.3.10'"                           >> /etc/config/dhcp
  echo ""                                                     >> /etc/config/dhcp
  echo "config domain"                                        >> /etc/config/dhcp
  echo "  option name 'servidor.home.arpa'"                   >> /etc/config/dhcp
  echo "  option ip '192.168.1.10'"                           >> /etc/config/dhcp

# /etc/config/wireless
  echo ""                                  > /etc/config/wireless
  echo "config wifi-device 'radio0'"      >> /etc/config/wireless
  echo "  option type 'mac80211'"         >> /etc/config/wireless
  echo "  #option path ''"                >> /etc/config/wireless
  echo "  option channel 'auto'"          >> /etc/config/wireless
  echo "  option band '2g'"               >> /etc/config/wireless
  echo "  option htmode 'HE20'"           >> /etc/config/wireless
  echo "  option cell_density '0'"        >> /etc/config/wireless
  echo "  option country 'ES'"            >> /etc/config/wireless
  echo ""                                 >> /etc/config/wireless
  echo "config wifi-iface 'wifiradio0_1'" >> /etc/config/wireless
  echo "  option device 'radio0'"         >> /etc/config/wireless
  echo "  option network 'lan'"           >> /etc/config/wireless
  echo "  option mode 'ap'"               >> /etc/config/wireless
  echo "  option ssid 'OpenWrt'"          >> /etc/config/wireless
  echo "  option encryption 'sae-mixed'"  >> /etc/config/wireless
  echo "  option key 'P@ssw0rd'"          >> /etc/config/wireless
  echo ""                                 >> /etc/config/wireless
  echo "config wifi-iface 'wifiradio0_2'" >> /etc/config/wireless
  echo "  option device 'radio0'"         >> /etc/config/wireless
  echo "  option mode 'ap'"               >> /etc/config/wireless
  echo "  option ssid 'IoT'"              >> /etc/config/wireless
  echo "  option encryption 'psk2'"       >> /etc/config/wireless
  echo "  option key 'P@ssw0rd'"          >> /etc/config/wireless
  echo "  option network 'iot'"           >> /etc/config/wireless
  echo ""                                 >> /etc/config/wireless
  echo "config wifi-iface 'wifiradio0_3'" >> /etc/config/wireless
  echo "  option device 'radio0'"         >> /etc/config/wireless
  echo "  option mode 'ap'"               >> /etc/config/wireless
  echo "  option ssid 'Invitados'"        >> /etc/config/wireless
  echo "  option encryption 'sae-mixed'"  >> /etc/config/wireless
  echo "  option key 'P@ssw0rd'"          >> /etc/config/wireless
  echo "  option network 'inv'"           >> /etc/config/wireless
  echo ""                                 >> /etc/config/wireless
  echo "config wifi-device 'radio1'"      >> /etc/config/wireless
  echo "  option type 'mac80211'"         >> /etc/config/wireless
  echo "  #option path ''"                >> /etc/config/wireless
  echo "  option channel 'auto'"          >> /etc/config/wireless
  echo "  option band '5g'"               >> /etc/config/wireless
  echo "  option htmode 'HE80'"           >> /etc/config/wireless
  echo "  option cell_density '0'"        >> /etc/config/wireless
  echo "  option country 'ES'"            >> /etc/config/wireless
  echo ""                                 >> /etc/config/wireless
  echo "config wifi-iface 'wifiradio1_1'" >> /etc/config/wireless
  echo "  option device 'radio1'"         >> /etc/config/wireless
  echo "  option network 'lan'"           >> /etc/config/wireless
  echo "  option mode 'ap'"               >> /etc/config/wireless
  echo "  option ssid 'OpenWrt'"          >> /etc/config/wireless
  echo "  option encryption 'sae-mixed'"  >> /etc/config/wireless
  echo "  option key 'P@ssw0rd'"          >> /etc/config/wireless
  echo ""                                 >> /etc/config/wireless
  echo "config wifi-iface 'wifiradio1_2'" >> /etc/config/wireless
  echo "  option device 'radio1'"         >> /etc/config/wireless
  echo "  option mode 'ap'"               >> /etc/config/wireless
  echo "  option ssid 'IoT'"              >> /etc/config/wireless
  echo "  option encryption 'psk2'"       >> /etc/config/wireless
  echo "  option key 'P@ssw0rd'"          >> /etc/config/wireless
  echo "  option network 'iot'"           >> /etc/config/wireless
  echo ""                                 >> /etc/config/wireless
  echo "config wifi-iface 'wifiradio1_3'" >> /etc/config/wireless
  echo "  option device 'radio1'"         >> /etc/config/wireless
  echo "  option mode 'ap'"               >> /etc/config/wireless
  echo "  option ssid 'Invitados'"        >> /etc/config/wireless
  echo "  option encryption 'sae-mixed'"  >> /etc/config/wireless
  echo "  option key 'P@ssw0rd'"          >> /etc/config/wireless
  echo "  option network 'inv'"           >> /etc/config/wireless

# Aplicar cambios
  echo ""

# Reiniciar
  reboot

