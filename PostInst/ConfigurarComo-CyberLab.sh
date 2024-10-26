#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para configurar OpenWrt como MV de Proxmox
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/o-scripts/master/PostInst/MVdeProxmox-Configurar.sh | sh
# ----------

# Definir variables de color
  vColorAzul="\033[0;34m"
  vColorAzulClaro="\033[1;34m"
  vColorVerde='\033[1;32m'
  vColorRojo='\033[1;31m'
  vFinColor='\033[0m'

# Notificar inicio de ejecución del script
  echo ""
  echo -e "${vColorAzulClaro}  Configurando OpenWrt para funcionar como laboratorio de ciberseguridad...${vFinColor}"
  echo ""

# /etc/config/network
  echo ""                                                                     > /etc/config/network
  echo "config interface 'loopback'"                                         >> /etc/config/network
  echo "  option device 'lo'"                                                >> /etc/config/network
  echo "  option proto 'static'"                                             >> /etc/config/network
  echo "  option ipaddr '127.0.0.1'"                                         >> /etc/config/network
  echo "  option netmask '255.0.0.0'"                                        >> /etc/config/network
  echo ""                                                                    >> /etc/config/network
  echo "config interface 'intwan'"                                           >> /etc/config/network
  echo "  option device 'eth0'"                                              >> /etc/config/network
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
  echo "  list ports 'eth1'"                                                 >> /etc/config/network
  echo ""                                                                    >> /etc/config/network
  echo "config interface 'intlan'"                                           >> /etc/config/network
  echo "  option device 'br-lan'"                                            >> /etc/config/network
  echo "  option proto 'static'"                                             >> /etc/config/network
  echo "  option ipaddr '192.168.100.1'"                                     >> /etc/config/network
  echo "  option netmask '255.255.255.0'"                                    >> /etc/config/network
  echo "  option delegate '0'"                                               >> /etc/config/network
  echo ""                                                                    >> /etc/config/network
  echo "config device"                                                       >> /etc/config/network
  echo "  option name 'br-lab'"                                              >> /etc/config/network
  echo "  option type 'bridge'"                                              >> /etc/config/network
  echo "  option bridge_empty '1'"                                           >> /etc/config/network
  echo "  list ports 'eth2'"                                                 >> /etc/config/network
  echo ""                                                                    >> /etc/config/network
  echo "config interface 'intlab'"                                           >> /etc/config/network
  echo "  option proto 'static'"                                             >> /etc/config/network
  echo "  option ipaddr '192.168.200.1'"                                     >> /etc/config/network
  echo "  option netmask '255.255.255.0'"                                    >> /etc/config/network
  echo "  option device 'br-lab'"                                            >> /etc/config/network
  echo "  option delegate '0'"                                               >> /etc/config/network
  echo ""                                                                    >> /etc/config/network

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
  echo "  option name 'zonawan'"         >> /etc/config/firewall
  echo "  list network 'intwan'"         >> /etc/config/firewall
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
  echo "  option name 'zonalab'"         >> /etc/config/firewall
  echo "  list network 'intlab'"         >> /etc/config/firewall
  echo "  option input 'DROP'"           >> /etc/config/firewall
  echo "  option output 'ACCEPT'"        >> /etc/config/firewall
  echo "  option forward 'DROP'"         >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config forwarding"               >> /etc/config/firewall
  echo "  option src 'zonalan'"          >> /etc/config/firewall
  echo "  option dest 'zonawan'"         >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config forwarding"               >> /etc/config/firewall
  echo "  option src 'zonalab'"          >> /etc/config/firewall
  echo "  option dest 'zonawan'"         >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config forwarding"               >> /etc/config/firewall
  echo "  option src 'zonalan'"          >> /etc/config/firewall
  echo "  option dest 'zonalab'"         >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config rule"                     >> /etc/config/firewall
  echo "  option name 'wan in ssh'"      >> /etc/config/firewall
  echo "  option src 'zonawan'"          >> /etc/config/firewall
  echo "  list proto 'tcp'"              >> /etc/config/firewall
  echo "  option dest_port '22'"         >> /etc/config/firewall
  echo "  option target 'ACCEPT'"        >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config rule"                     >> /etc/config/firewall
  echo "  option name 'wan in LUCI'"     >> /etc/config/firewall
  echo "  option src 'zonawan'"          >> /etc/config/firewall
  echo "  list proto 'tcp'"              >> /etc/config/firewall
  echo "  option dest_port '80'"         >> /etc/config/firewall
  echo "  option target 'ACCEPT'"        >> /etc/config/firewall
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
  echo "  option name 'lab in DHCP'"     >> /etc/config/firewall
  echo "  list proto 'udp'"              >> /etc/config/firewall
  echo "  option src 'zonalab'"          >> /etc/config/firewall
  echo "  option dest_port '67 68'"      >> /etc/config/firewall
  echo "  option target 'ACCEPT'"        >> /etc/config/firewall
  echo "  option family 'ipv4'"          >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall
  echo "config rule"                     >> /etc/config/firewall
  echo "  option name 'lab in DNS'"      >> /etc/config/firewall
  echo "  list proto 'udp'"              >> /etc/config/firewall
  echo "  option src 'zonalab'"          >> /etc/config/firewall
  echo "  option dest_port '53'"         >> /etc/config/firewall
  echo "  option target 'ACCEPT'"        >> /etc/config/firewall
  echo "  option family 'ipv4'"          >> /etc/config/firewall
  echo ""                                >> /etc/config/firewall

# /etc/config/dhcp
  echo ""                                                           > /etc/config/dhcp
  echo "config odhcpd 'odhcpd'"                                    >> /etc/config/dhcp
  echo "  option maindhcp '0'"                                     >> /etc/config/dhcp
  echo "  option leasefile '/tmp/hosts/odhcpd'"                    >> /etc/config/dhcp
  echo "  option leasetrigger '/usr/sbin/odhcpd-update'"           >> /etc/config/dhcp
  echo "  option loglevel '4'"                                     >> /etc/config/dhcp
  echo ""                                                          >> /etc/config/dhcp
  echo "config dhcp 'wan'"                                         >> /etc/config/dhcp
  echo "  option interface 'intwan'"                               >> /etc/config/dhcp
  echo "  option ignore '1'"                                       >> /etc/config/dhcp
  echo ""                                                          >> /etc/config/dhcp
  echo "config dhcp 'intlan'"                                      >> /etc/config/dhcp
  echo "  option interface 'intlan'"                               >> /etc/config/dhcp
  echo "  option start '100'"                                      >> /etc/config/dhcp
  echo "  option limit '150'"                                      >> /etc/config/dhcp
  echo "  option leasetime '12h'"                                  >> /etc/config/dhcp
  echo "  option dhcpv4 'server'"                                  >> /etc/config/dhcp
  echo "  option force '1'"                                        >> /etc/config/dhcp
  echo ""                                                          >> /etc/config/dhcp
  echo "config dnsmasq 'intlan_dns'"                               >> /etc/config/dhcp
  echo "  option domainneeded '1'"                                 >> /etc/config/dhcp
  echo "  option localise_queries '1'"                             >> /etc/config/dhcp
  echo "  option rebind_protection '1'"                            >> /etc/config/dhcp
  echo "  option rebind_localhost '1'"                             >> /etc/config/dhcp
  echo "  option local '/lan/'"                                    >> /etc/config/dhcp
  echo "  option domain 'lan.home.arpa'"                           >> /etc/config/dhcp
  echo "  option expandhosts '1'"                                  >> /etc/config/dhcp
  echo "  option authoritative '1'"                                >> /etc/config/dhcp
  echo "  option readethers '1'"                                   >> /etc/config/dhcp
  echo "  option leasefile '/tmp/dhcp.leases.intlan'"              >> /etc/config/dhcp
  echo "  option resolvfile '/tmp/resolv.conf.d/resolv.conf.auto'" >> /etc/config/dhcp
  echo "  option localservice '0'"                                 >> /etc/config/dhcp
  echo "  option sequential_ip '1'"                                >> /etc/config/dhcp
  echo "  list interface 'intlan'"                                 >> /etc/config/dhcp
  echo "  list notinterface 'loopback'"                            >> /etc/config/dhcp
  echo "  option logqueries '1'"                                   >> /etc/config/dhcp
  echo "  option logdhcp '1'"                                      >> /etc/config/dhcp
  echo "  option port '53'"                                        >> /etc/config/dhcp
  echo ""                                                          >> /etc/config/dhcp
  echo "config dhcp 'intlab'"                                      >> /etc/config/dhcp
  echo "  option interface 'intlab'"                               >> /etc/config/dhcp
  echo "  option start '100'"                                      >> /etc/config/dhcp
  echo "  option limit '150'"                                      >> /etc/config/dhcp
  echo "  option leasetime '12h'"                                  >> /etc/config/dhcp
  echo "  option dhcpv4 'server'"                                  >> /etc/config/dhcp
  echo "  option force '1'"                                        >> /etc/config/dhcp
  echo ""                                                          >> /etc/config/dhcp
  echo "config dnsmasq 'intlab_dns'"                               >> /etc/config/dhcp
  echo "  option domainneeded '1'"                                 >> /etc/config/dhcp
  echo "  option localise_queries '1'"                             >> /etc/config/dhcp
  echo "  option rebind_protection '1'"                            >> /etc/config/dhcp
  echo "  option rebind_localhost '1'"                             >> /etc/config/dhcp
  echo "  option local '/lab/'"                                    >> /etc/config/dhcp
  echo "  option domain 'lab.home.arpa'"                           >> /etc/config/dhcp
  echo "  option expandhosts '1'"                                  >> /etc/config/dhcp
  echo "  option authoritative '1'"                                >> /etc/config/dhcp
  echo "  option readethers '1'"                                   >> /etc/config/dhcp
  echo "  option leasefile '/tmp/dhcp.leases.intlab'"              >> /etc/config/dhcp
  echo "  option resolvfile '/tmp/resolv.conf.d/resolv.conf.auto'" >> /etc/config/dhcp
  echo "  option localservice '0'"                                 >> /etc/config/dhcp
  echo "  option sequential_ip '1'"                                >> /etc/config/dhcp
  echo "  list interface 'intlab'"                                 >> /etc/config/dhcp
  echo "  list notinterface 'loopback'"                            >> /etc/config/dhcp
  echo "  option logqueries '1'"                                   >> /etc/config/dhcp
  echo "  option logdhcp '1'"                                      >> /etc/config/dhcp
  echo "  option port '53'"                                        >> /etc/config/dhcp
  echo ""                                                          >> /etc/config/dhcp
  echo "config host"                                               >> /etc/config/dhcp
  echo "  option name 'host1lan'"                                  >> /etc/config/dhcp
  echo "  option dns '1'"                                          >> /etc/config/dhcp
  echo "  option mac '00:00:aa:aa:aa:aa'"                          >> /etc/config/dhcp
  echo "  option ip '192.168.100.10'"                              >> /etc/config/dhcp
  echo ""                                                          >> /etc/config/dhcp
  echo "config host"                                               >> /etc/config/dhcp
  echo "  option name 'host1lab'"                                  >> /etc/config/dhcp
  echo "  option dns '1'"                                          >> /etc/config/dhcp
  echo "  option mac '00:00:bb:bb:bb:bb'"                          >> /etc/config/dhcp
  echo "  option ip '192.168.200.10'"                              >> /etc/config/dhcp
  echo ""                                                          >> /etc/config/dhcp

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
  echo "  option network 'intlan'"        >> /etc/config/wireless
  echo "  option mode 'ap'"               >> /etc/config/wireless
  echo "  option ssid 'OpenWrt-lan'"      >> /etc/config/wireless
  echo "  option encryption 'sae-mixed'"  >> /etc/config/wireless
  echo "  option key 'P@ssw0rd'"          >> /etc/config/wireless
  echo ""                                 >> /etc/config/wireless
  echo "config wifi-iface 'wifiradio0_2'" >> /etc/config/wireless
  echo "  option device 'radio0'"         >> /etc/config/wireless
  echo "  option mode 'ap'"               >> /etc/config/wireless
  echo "  option network 'intlab'"        >> /etc/config/wireless
  echo "  option ssid 'OpenWrt-lab'"      >> /etc/config/wireless
  echo "  option encryption 'psk2'"       >> /etc/config/wireless
  echo "  option key 'P@ssw0rd'"          >> /etc/config/wireless
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
  echo "  option network ' intlan'"       >> /etc/config/wireless
  echo "  option mode 'ap'"               >> /etc/config/wireless
  echo "  option ssid 'OpenWrt-lan'"      >> /etc/config/wireless
  echo "  option encryption 'sae-mixed'"  >> /etc/config/wireless
  echo "  option key 'P@ssw0rd'"          >> /etc/config/wireless
  echo ""                                 >> /etc/config/wireless
  echo "config wifi-iface 'wifiradio1_2'" >> /etc/config/wireless
  echo "  option device 'radio1'"         >> /etc/config/wireless
  echo "  option network 'intlab'"        >> /etc/config/wireless
  echo "  option mode 'ap'"               >> /etc/config/wireless
  echo "  option ssid 'OpenWrt-lab'"      >> /etc/config/wireless
  echo "  option encryption 'psk2'"       >> /etc/config/wireless
  echo "  option key 'P@ssw0rd'"          >> /etc/config/wireless
  echo ""                                 >> /etc/config/wireless

# Aplicar cambios
  echo ""

# Reiniciar
  reboot

