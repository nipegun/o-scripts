#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para configurar un router OpenWrt para conectar su puerto wan a otro router mediante DHCP
#
# Este script asigna los puertos eth1 (el sfp1 de la izquierda) y el puerto sfp2 al puente LAN (br-lan).
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/o-scripts/master/PostInst/Configurar-BPIR3-wan_dhcp-brlan_conETH1ySFP2.sh | sh
# ----------

# Definir variables de color
  vColorAzul="\033[0;34m"
  vColorAzulClaro="\033[1;34m"
  vColorVerde='\033[1;32m'
  vColorRojo='\033[1;31m'
  vFinColor='\033[0m'

# Notificar inicio de ejecución del script
  echo ""
  echo -e "${vColorAzulClaro}  Configurando la BPI-R3 para conectar su WAN a otro router mediante DHCP...${vFinColor}"
  echo ""

# /etc/config/network
  echo ""                                                                     > /etc/config/network
  echo "config interface 'loopback'"                                         >> /etc/config/network
  echo "  option device 'lo'"                                                >> /etc/config/network
  echo "  option proto 'static'"                                             >> /etc/config/network
  echo "  option ipaddr '127.0.0.1'"                                         >> /etc/config/network
  echo "  option netmask '255.0.0.0'"                                        >> /etc/config/network
  echo ""                                                                    >> /etc/config/network
  echo "config interface 'wwan'"                                             >> /etc/config/network
  echo "  option proto 'dhcp'"                                               >> /etc/config/network
  echo "  option device 'wwan0'"                                             >> /etc/config/network
  echo "  option hostname '*'"                                               >> /etc/config/network
  echo ""                                                                    >> /etc/config/network
  echo "config interface 'wwan6'"                                            >> /etc/config/network
  echo "  option proto 'dhcpv6'"                                             >> /etc/config/network
  echo "  option device 'wwan0'"                                             >> /etc/config/network
  echo "  option reqaddress 'try'"                                           >> /etc/config/network
  echo "  option reqprefix 'auto'"                                           >> /etc/config/network
  echo "  option hostname '*'"                                               >> /etc/config/network
  echo ""                                                                    >> /etc/config/network
  echo "config interface 'wan'"                                              >> /etc/config/network
  echo "  option device 'wan'"                                               >> /etc/config/network
  echo "  option proto 'dhcp'"                                               >> /etc/config/network
  echo "  option hostname '*'"                                               >> /etc/config/network
  echo "  option peerdns '0'"                                                >> /etc/config/network
  echo "  option delegate '0'"                                               >> /etc/config/network
  echo "  list dns '9.9.9.9'"                                                >> /etc/config/network
  echo "  list dns '149.112.112.112'"                                        >> /etc/config/network
  echo ""                                                                    >> /etc/config/network
  echo "config device"                                                       >> /etc/config/network
  echo "  option name 'br-lan'"                                              >> /etc/config/network
  echo "  option type 'bridge'"                                              >> /etc/config/network
  echo "  option bridge_empty '1'"                                           >> /etc/config/network
  echo "  option macaddr '00:00:0c:00:b1:00'"                                >> /etc/config/network
  echo "  list ports 'eth1'"                                                 >> /etc/config/network
  echo "  list ports 'sfp2'"                                                 >> /etc/config/network
  echo "  list ports 'lan1'"                                                 >> /etc/config/network
  echo "  list ports 'lan2'"                                                 >> /etc/config/network
  echo "  list ports 'lan3'"                                                 >> /etc/config/network
  echo "  list ports 'lan4'"                                                 >> /etc/config/network
  echo ""                                                                    >> /etc/config/network
  echo "config interface 'lan'"                                              >> /etc/config/network
  echo "  option device 'br-lan'"                                            >> /etc/config/network
  echo "  option proto 'static'"                                             >> /etc/config/network
  echo "  option ipaddr '192.168.0.1'"                                       >> /etc/config/network
  echo "  option netmask '255.255.255.0'"                                    >> /etc/config/network
  echo "  option delegate '0'"                                               >> /etc/config/network
  echo ""                                                                    >> /etc/config/network
  echo "config device"                                                       >> /etc/config/network
  echo "  option name 'br-iot'"                                              >> /etc/config/network
  echo "  option type 'bridge'"                                              >> /etc/config/network
  echo "  option bridge_empty '1'"                                           >> /etc/config/network
  echo "  option macaddr '00:00:0c:00:b2:00'"                                >> /etc/config/network
  echo ""                                                                    >> /etc/config/network
  echo "config interface 'iot'"                                              >> /etc/config/network
  echo "  option proto 'static'"                                             >> /etc/config/network
  echo "  option ipaddr '192.168.2.1'"                                       >> /etc/config/network
  echo "  option netmask '255.255.255.0'"                                    >> /etc/config/network
  echo "  option device 'br-iot'"                                            >> /etc/config/network
  echo "  option delegate '0'"                                               >> /etc/config/network
  echo ""                                                                    >> /etc/config/network
  echo "config device"                                                       >> /etc/config/network
  echo "  option name 'br-inv'"                                              >> /etc/config/network
  echo "  option type 'bridge'"                                              >> /etc/config/network
  echo "  option bridge_empty '1'"                                           >> /etc/config/network
  echo "  option macaddr '00:00:0c:00:b3:00'"                                >> /etc/config/network
  echo ""                                                                    >> /etc/config/network
  echo "config interface 'inv'"                                              >> /etc/config/network
  echo "  option proto 'static'"                                             >> /etc/config/network
  echo "  option ipaddr '192.168.3.1'"                                       >> /etc/config/network
  echo "  option netmask '255.255.255.0'"                                    >> /etc/config/network
  echo "  option device 'br-inv'"                                            >> /etc/config/network
  echo "  option delegate '0'"                                               >> /etc/config/network
  echo ""                                                                    >> /etc/config/network
  echo "config interface 'vpn'"                                              >> /etc/config/network
  echo "  option proto 'wireguard'"                                          >> /etc/config/network
  echo "  option private_key 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx='" >> /etc/config/network
  echo "  option listen_port '51820'"                                        >> /etc/config/network
  echo "  list addresses '192.168.255.1/24'"                                 >> /etc/config/network
  echo "  option force_link '1'"                                             >> /etc/config/network
  echo "  option delegate '0'"                                               >> /etc/config/network

# /etc/config/firewall
  echo ""                                 > /etc/config/firewall
  echo "config defaults"                 >> /etc/config/firewall
  echo "  option input 'ACCEPT'"         >> /etc/config/firewall
  echo "  option output 'ACCEPT'"        >> /etc/config/firewall
  echo "  option forward 'DROP'"         >> /etc/config/firewall
  echo "  option synflood_protect '1'"   >> /etc/config/firewall
  echo "  option drop_invalid '1'"       >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config zone"                     >> /etc/config/firewall
  echo "  option name 'wan'"             >> /etc/config/firewall
  echo "  list network 'wan'"            >> /etc/config/firewall
  echo "  list network 'wan6'"           >> /etc/config/firewall
  echo "  option input 'DROP'"           >> /etc/config/firewall
  echo "  option output 'ACCEPT'"        >> /etc/config/firewall
  echo "  option forward 'DROP'"         >> /etc/config/firewall
  echo "  option masq '1'"               >> /etc/config/firewall
  echo "  option mtu_fix '1'"            >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config zone"                     >> /etc/config/firewall
  echo "  option name 'lan'"             >> /etc/config/firewall
  echo "  list network 'lan'"            >> /etc/config/firewall
  echo "  option input 'ACCEPT'"         >> /etc/config/firewall
  echo "  option output 'ACCEPT'"        >> /etc/config/firewall
  echo "  option forward 'ACCEPT'"       >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config zone"                     >> /etc/config/firewall
  echo "  option name 'iot'"             >> /etc/config/firewall
  echo "  option input 'DROP'"           >> /etc/config/firewall
  echo "  option output 'ACCEPT'"        >> /etc/config/firewall
  echo "  option forward 'DROP'"         >> /etc/config/firewall
  echo "  list network 'iot'"            >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config zone"                     >> /etc/config/firewall
  echo "  option name 'inv'"             >> /etc/config/firewall
  echo "  option input 'DROP'"           >> /etc/config/firewall
  echo "  option output 'ACCEPT'"        >> /etc/config/firewall
  echo "  option forward 'DROP'"         >> /etc/config/firewall
  echo "  list network 'inv'"            >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config zone"                     >> /etc/config/firewall
  echo "  option name 'vpn'"             >> /etc/config/firewall
  echo "  option input 'ACCEPT'"         >> /etc/config/firewall
  echo "  option output 'ACCEPT'"        >> /etc/config/firewall
  echo "  option forward 'ACCEPT'"       >> /etc/config/firewall
  echo "  list network 'vpn'"            >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config rule"                     >> /etc/config/firewall
  echo "  option name 'wan in DHCP'"     >> /etc/config/firewall
  echo "  option src 'wan'"              >> /etc/config/firewall
  echo "  option proto 'udp'"            >> /etc/config/firewall
  echo "  option dest_port '68'"         >> /etc/config/firewall
  echo "  option target 'ACCEPT'"        >> /etc/config/firewall
  echo "  option family 'ipv4'"          >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config rule"                     >> /etc/config/firewall
  echo "  option name 'wan in PING'"     >> /etc/config/firewall
  echo "  option src 'wan'"              >> /etc/config/firewall
  echo "  option proto 'icmp'"           >> /etc/config/firewall
  echo "  option family 'ipv4'"          >> /etc/config/firewall
  echo "  option target 'ACCEPT'"        >> /etc/config/firewall
  echo "  list icmp_type 'echo-request'" >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config rule"                     >> /etc/config/firewall
  echo "  option name 'wan in WG'"       >> /etc/config/firewall
  echo "  option src 'wan'"              >> /etc/config/firewall
  echo "  option proto 'udp'"            >> /etc/config/firewall
  echo "  option dest_port '51820'"      >> /etc/config/firewall
  echo "  option target 'ACCEPT'"        >> /etc/config/firewall
  echo "  option family 'ipv4'"          >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config forwarding"               >> /etc/config/firewall
  echo "  option src 'lan'"              >> /etc/config/firewall
  echo "  option dest 'wan'"             >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config forwarding"               >> /etc/config/firewall
  echo "  option src 'lan'"              >> /etc/config/firewall
  echo "  option dest 'iot'"             >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config forwarding"               >> /etc/config/firewall
  echo "  option src 'lan'"              >> /etc/config/firewall
  echo "  option dest 'inv'"             >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config forwarding"               >> /etc/config/firewall
  echo "  option src 'lan'"              >> /etc/config/firewall
  echo "  option dest 'vpn'"             >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config forwarding"               >> /etc/config/firewall
  echo "  option src 'iot'"              >> /etc/config/firewall
  echo "  option dest 'wan'"             >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config forwarding"               >> /etc/config/firewall
  echo "  option src 'inv'"              >> /etc/config/firewall
  echo "  option dest 'wan'"             >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config forwarding"               >> /etc/config/firewall
  echo "  option src 'vpn'"              >> /etc/config/firewall
  echo "  option dest 'wan'"             >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config forwarding"               >> /etc/config/firewall
  echo "  option src 'vpn'"              >> /etc/config/firewall
  echo "  option dest 'lan'"             >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config forwarding"               >> /etc/config/firewall
  echo "  option src 'vpn'"              >> /etc/config/firewall
  echo "  option dest 'iot'"             >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config forwarding"               >> /etc/config/firewall
  echo "  option src 'vpn'"              >> /etc/config/firewall
  echo "  option dest 'inv'"             >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config rule"                     >> /etc/config/firewall
  echo "  option name 'iot in DHCP'"     >> /etc/config/firewall
  echo "  list proto 'udp'"              >> /etc/config/firewall
  echo "  option src 'iot'"              >> /etc/config/firewall
  echo "  option dest_port '67 68'"      >> /etc/config/firewall
  echo "  option target 'ACCEPT'"        >> /etc/config/firewall
  echo "  option family 'ipv4'"          >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config rule"                     >> /etc/config/firewall
  echo "  option name 'iot in DNS'"      >> /etc/config/firewall
  echo "  list proto 'udp'"              >> /etc/config/firewall
  echo "  option src 'iot'"              >> /etc/config/firewall
  echo "  option dest_port '53'"         >> /etc/config/firewall
  echo "  option target 'ACCEPT'"        >> /etc/config/firewall
  echo "  option family 'ipv4'"          >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config rule"                     >> /etc/config/firewall
  echo "  option name 'inv in DHCP'"     >> /etc/config/firewall
  echo "  list proto 'udp'"              >> /etc/config/firewall
  echo "  option src 'inv'"              >> /etc/config/firewall
  echo "  option dest_port '67 68'"      >> /etc/config/firewall
  echo "  option target 'ACCEPT'"        >> /etc/config/firewall
  echo "  option family 'ipv4'"          >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config rule"                     >> /etc/config/firewall
  echo "  option name 'inv in DNS'"      >> /etc/config/firewall
  echo "  option src 'inv'"              >> /etc/config/firewall
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
  echo "config dhcp 'wan'"                                    >> /etc/config/dhcp
  echo "  option interface 'wan'"                             >> /etc/config/dhcp
  echo "  option ignore '1'"                                  >> /etc/config/dhcp
  echo ""                                                     >> /etc/config/dhcp
  echo "config dhcp 'lan'"                                    >> /etc/config/dhcp
  echo "  option interface 'lan'"                             >> /etc/config/dhcp
  echo "  option start '100'"                                 >> /etc/config/dhcp
  echo "  option limit '99'"                                  >> /etc/config/dhcp
  echo "  option leasetime '12h'"                             >> /etc/config/dhcp
  echo "  option dhcpv4 'server'"                             >> /etc/config/dhcp
  echo "  option force '1'"                                   >> /etc/config/dhcp
  echo ""                                                     >> /etc/config/dhcp
  echo "config dhcp 'iot'"                                    >> /etc/config/dhcp
  echo "  option interface 'iot'"                             >> /etc/config/dhcp
  echo "  option start '100'"                                 >> /etc/config/dhcp
  echo "  option limit '99'"                                  >> /etc/config/dhcp
  echo "  option leasetime '12h'"                             >> /etc/config/dhcp
  echo "  option force '1'"                                   >> /etc/config/dhcp
  echo ""                                                     >> /etc/config/dhcp
  echo "config dhcp 'inv'"                                    >> /etc/config/dhcp
  echo "  option interface 'inv'"                             >> /etc/config/dhcp
  echo "  option start '100'"                                 >> /etc/config/dhcp
  echo "  option limit '99'"                                  >> /etc/config/dhcp
  echo "  option leasetime '12h'"                             >> /etc/config/dhcp
  echo "  option force '1'"                                   >> /etc/config/dhcp
  echo ""                                                     >> /etc/config/dhcp
  echo "config host"                                          >> /etc/config/dhcp
  echo "  option name 'hostlan'"                              >> /etc/config/dhcp
  echo "  option dns '1'"                                     >> /etc/config/dhcp
  echo "  option mac '00:00:aa:aa:aa:aa'"                     >> /etc/config/dhcp
  echo "  option ip '192.168.1.10'"                           >> /etc/config/dhcp
  echo ""                                                     >> /etc/config/dhcp
  echo "config host"                                          >> /etc/config/dhcp
  echo "  option name 'hostiot'"                              >> /etc/config/dhcp
  echo "  option dns '1'"                                     >> /etc/config/dhcp
  echo "  option mac '00:00:bb:bb:bb:bb'"                     >> /etc/config/dhcp
  echo "  option ip '192.168.2.10'"                           >> /etc/config/dhcp
  echo ""                                                     >> /etc/config/dhcp
  echo "config host"                                          >> /etc/config/dhcp
  echo "  option name 'hostinv'"                              >> /etc/config/dhcp
  echo "  option dns '1'"                                     >> /etc/config/dhcp
  echo "  option mac '00:00:cc:cc:cc:cc'"                     >> /etc/config/dhcp
  echo "  option ip '192.168.3.10'"                           >> /etc/config/dhcp

# /etc/config/wireless
  echo ""                                              > /etc/config/wireless
  echo "config wifi-device 'radio0'"                  >> /etc/config/wireless
  echo "  option type 'mac80211'"                     >> /etc/config/wireless
  echo "  option path 'platform/soc/18000000.wifi'"   >> /etc/config/wireless
  echo "  option channel 'auto'"                      >> /etc/config/wireless
  echo "  option band '2g'"                           >> /etc/config/wireless
  echo "  option htmode 'HE20'"                       >> /etc/config/wireless
  echo "  option cell_density '0'"                    >> /etc/config/wireless
  echo "  option country 'ES'"                        >> /etc/config/wireless
  echo ""                                             >> /etc/config/wireless
  echo "config wifi-iface 'wifiradio0_1'"             >> /etc/config/wireless
  echo "  option device 'radio0'"                     >> /etc/config/wireless
  echo "  option network 'lan'"                       >> /etc/config/wireless
  echo "  option mode 'ap'"                           >> /etc/config/wireless
  echo "  option ssid 'BPIR3-OpenWrt'"                >> /etc/config/wireless
  echo "  option encryption 'sae-mixed'"              >> /etc/config/wireless
  echo "  option key 'P@ssw0rd'"                      >> /etc/config/wireless
  echo ""                                             >> /etc/config/wireless
  echo "config wifi-iface 'wifiradio0_2'"             >> /etc/config/wireless
  echo "  option device 'radio0'"                     >> /etc/config/wireless
  echo "  option mode 'ap'"                           >> /etc/config/wireless
  echo "  option ssid 'BPIR3-IoT'"                    >> /etc/config/wireless
  echo "  option encryption 'psk2'"                   >> /etc/config/wireless
  echo "  option key 'P@ssw0rd'"                      >> /etc/config/wireless
  echo "  option network 'iot'"                       >> /etc/config/wireless
  echo ""                                             >> /etc/config/wireless
  echo "config wifi-iface 'wifiradio0_3'"             >> /etc/config/wireless
  echo "  option device 'radio0'"                     >> /etc/config/wireless
  echo "  option mode 'ap'"                           >> /etc/config/wireless
  echo "  option ssid 'BPIR3-Invitados'"              >> /etc/config/wireless
  echo "  option encryption 'sae-mixed'"              >> /etc/config/wireless
  echo "  option key 'P@ssw0rd'"                      >> /etc/config/wireless
  echo "  option network 'inv'"                       >> /etc/config/wireless
  echo ""                                             >> /etc/config/wireless
  echo "config wifi-device 'radio1'"                  >> /etc/config/wireless
  echo "  option type 'mac80211'"                     >> /etc/config/wireless
  echo "  option path 'platform/soc/18000000.wifi+1'" >> /etc/config/wireless
  echo "  option channel 'auto'"                      >> /etc/config/wireless
  echo "  option band '5g'"                           >> /etc/config/wireless
  echo "  option htmode 'HE80'"                       >> /etc/config/wireless
  echo "  option cell_density '0'"                    >> /etc/config/wireless
  echo "  option country 'ES'"                        >> /etc/config/wireless
  echo ""                                             >> /etc/config/wireless
  echo "config wifi-iface 'wifiradio1_1'"             >> /etc/config/wireless
  echo "  option device 'radio1'"                     >> /etc/config/wireless
  echo "  option network 'lan'"                       >> /etc/config/wireless
  echo "  option mode 'ap'"                           >> /etc/config/wireless
  echo "  option ssid 'BPIR3-OpenWrt'"                >> /etc/config/wireless
  echo "  option encryption 'sae-mixed'"              >> /etc/config/wireless
  echo "  option key 'P@ssw0rd'"                      >> /etc/config/wireless
  echo ""                                             >> /etc/config/wireless
  echo "config wifi-iface 'wifiradio1_2'"             >> /etc/config/wireless
  echo "  option device 'radio1'"                     >> /etc/config/wireless
  echo "  option mode 'ap'"                           >> /etc/config/wireless
  echo "  option ssid 'BPIR3-IoT'"                    >> /etc/config/wireless
  echo "  option encryption 'psk2'"                   >> /etc/config/wireless
  echo "  option key 'P@ssw0rd'"                      >> /etc/config/wireless
  echo "  option network 'iot'"                       >> /etc/config/wireless
  echo ""                                             >> /etc/config/wireless
  echo "config wifi-iface 'wifiradio1_3'"             >> /etc/config/wireless
  echo "  option device 'radio1'"                     >> /etc/config/wireless
  echo "  option mode 'ap'"                           >> /etc/config/wireless
  echo "  option ssid 'BPIR3-Invitados'"              >> /etc/config/wireless
  echo "  option encryption 'sae-mixed'"              >> /etc/config/wireless
  echo "  option key 'P@ssw0rd'"                      >> /etc/config/wireless
  echo "  option network 'inv'"                       >> /etc/config/wireless

# Aplicar cambios
  echo ""

# Reiniciar
  reboot
