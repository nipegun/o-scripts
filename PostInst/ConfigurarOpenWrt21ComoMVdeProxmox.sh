#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------------
#  Script de NiPeGun para configurar OpenWrt 21 como MV de Proxmox
#-------------------------------------------------------------------

ColorVerde="\033[1;32m"
FinColor="\033[0m"

echo ""
echo -e "${ColorVerde}Configurando OpenWrt 21 como máquina virtual de Proxmox...${FinColor}"
echo ""

# Configurar red e interfaces
echo "config interface 'loopback'"                  > /etc/config/network
echo "  option ifname 'lo'"                        >> /etc/config/network
echo "  option proto 'static'"                     >> /etc/config/network
echo "  option ipaddr '127.0.0.1'"                 >> /etc/config/network
echo "  option netmask '255.0.0.0'"                >> /etc/config/network
echo ""                                            >> /etc/config/network
echo "config interface 'WAN'"                      >> /etc/config/network
echo "  option ifname 'eth0'"                      >> /etc/config/network
echo "  option proto 'static'"                     >> /etc/config/network
echo "  option gateway '192.168.1.1'"              >> /etc/config/network
echo "  option ipaddr '192.168.1.201'"             >> /etc/config/network
echo "  option netmask '255.255.255.0'"            >> /etc/config/network
echo "  list dns '1.1.1.1'"                        >> /etc/config/network
echo ""                                            >> /etc/config/network
echo "config interface 'LAN'"                      >> /etc/config/network
echo "  option type 'bridge'"                      >> /etc/config/network
echo "  option ifname 'eth1 eth2 eth3 eth4'"       >> /etc/config/network
echo "  option proto 'static'"                     >> /etc/config/network
echo "  option ipaddr '192.168.2.1'"               >> /etc/config/network
echo "  option netmask '255.255.255.0'"            >> /etc/config/network
echo "  list dns '1.1.1.1'"                        >> /etc/config/network
echo "  option delegate '0'"                       >> /etc/config/network
echo "  option force_link '0'"                     >> /etc/config/network
# Permitir SSH desde WAN
echo "config rule"                                 >> /etc/config/firewall
echo "  option name 'Allow-SSH-WAN'"               >> /etc/config/firewall
echo "  option target 'ACCEPT'"                    >> /etc/config/firewall
echo "  list proto 'tcp'"                          >> /etc/config/firewall
echo "  option dest_port '22'"                     >> /etc/config/firewall
echo "  option src 'wan'"                          >> /etc/config/firewall
# Permitir LUCI desde WAN
echo "config rule"                                 >> /etc/config/firewall
echo "  option name 'Allow-LUCI-WAN'"              >> /etc/config/firewall
echo "  option target 'ACCEPT'"                    >> /etc/config/firewall
echo "  list proto 'tcp'"                          >> /etc/config/firewall
echo "  option dest_port '80'"                     >> /etc/config/firewall
echo "  option src 'wan'"                          >> /etc/config/firewall
# Adblock
mkdir -p /root/logs/dns/ 2> /dev/null
echo "config adblock 'global'"                      > /etc/config/adblock
echo "  option adb_dnsfilereset '0'"               >> /etc/config/adblock
echo "  option adb_backup '1'"                     >> /etc/config/adblock
echo "  option adb_maxqueue '4'"                   >> /etc/config/adblock
echo "  option adb_dns 'dnsmasq'"                  >> /etc/config/adblock
echo "  option adb_fetchutil 'uclient-fetch'"      >> /etc/config/adblock
echo "  option adb_report '1'"                     >> /etc/config/adblock
echo "  option adb_mail '1'"                       >> /etc/config/adblock
echo "  option adb_mailreceiver 'mail@gmail.com'"  >> /etc/config/adblock
echo "  option adb_dnsflush '1'"                   >> /etc/config/adblock
echo "  option adb_mailtopic 'AdBlock de OpenWrt'" >> /etc/config/adblock
echo "  option adb_debug '1'"                      >> /etc/config/adblock
echo "  option adb_forcedns '1'"                   >> /etc/config/adblock
echo "  list adb_sources 'adaway'"                 >> /etc/config/adblock
echo "  list adb_sources 'adguard'"                >> /etc/config/adblock
echo "  list adb_sources 'android_tracking'"       >> /etc/config/adblock
echo "  list adb_sources 'anti_ad'"                >> /etc/config/adblock
echo "  list adb_sources 'disconnect'"             >> /etc/config/adblock
echo "  list adb_sources 'firetv_tracking'"        >> /etc/config/adblock
echo "  list adb_sources 'malwaredomains'"         >> /etc/config/adblock
echo "  list adb_sources 'malwarelist'"            >> /etc/config/adblock
echo "  list adb_sources 'notracking'"             >> /etc/config/adblock
echo "  list adb_sources 'openphish'"              >> /etc/config/adblock
echo "  list adb_sources 'phishing_army'"          >> /etc/config/adblock
echo "  list adb_sources 'spam404'"                >> /etc/config/adblock
echo "  list adb_sources 'stopforumspam'"          >> /etc/config/adblock
echo "  list adb_sources 'whocares'"               >> /etc/config/adblock
echo "  list adb_safesearch '0'"                   >> /etc/config/adblock
echo "  list adb_reportdir '/root/logs/dns'"       >> /etc/config/adblock
echo "  list adb_repiface 'br-LAN'"                >> /etc/config/adblock
echo "  list adb_enabled '1'"                      >> /etc/config/adblock
# DHCP en LAN
echo "config dhcp 'LAN'"                           >> /etc/config/dhcp
echo "  option start '100'"                        >> /etc/config/dhcp
echo "  option leasetime '12h'"                    >> /etc/config/dhcp
echo "  option interface 'LAN'"                    >> /etc/config/dhcp
echo "  option limit '199'"                        >> /etc/config/dhcp

poweroff
