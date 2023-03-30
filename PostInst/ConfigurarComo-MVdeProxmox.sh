#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para configurar OpenWrt como MV de Proxmox
# ----------

vColorAzul="\033[0;34m"
vColorAzulClaro="\033[1;34m"
vColorVerde='\033[1;32m'
vColorRojo='\033[1;31m'
vFinColor='\033[0m'

# Menú principal
  echo ""
  echo "  Script de configuración de OpenWrt como máquina virtual de Proxmox."
  echo ""
  echo "Seleccione una opción:"
  echo ""
  echo "1. Configurar OpenWrt con 2 puertos ethernet asignados al puente LAN."
  echo "2. Configurar OpenWrt con 4 puertos ethernet asignados al puente LAN."
  echo ""

# Pedir al usuario que seleccione una opción
  read -p "Seleccione una opción [1-2]: " opcion

# Evaluar la opción seleccionada
  case $opcion in

    1)
      echo ""
      echo -e "${vColorAzulClaro}  Configurando OpenWrt como máquina virtual de Proxmox con 2 puertos ethernet asignados al puente LAN...${vFinColor}"
      echo ""
      curl -sL https://raw.githubusercontent.com/nipegun/o-scripts/master/PostInst/Proxmox-ConfigurarCon-PuenteLANcon4PuertosEthernet.sh| sh
    ;;

    2)
      echo ""
      echo -e "${vColorAzulClaro}  Configurando OpenWrt como máquina virtual de Proxmox con 4 puertos ethernet asignados al puente LAN...${vFinColor}"
      echo ""
      curl -sL https://raw.githubusercontent.com/nipegun/o-scripts/master/PostInst/Proxmox-ConfigurarCon-PuenteLANcon4PuertosEthernet.sh | sh
    ;;

    *)
      echo ""
      echo "Opción inválida, seleccione una opción válida [1-2]"
      echo ""
    ;;
esac

# Salir del script
  exit 0




echo ""
echo -e "${vColorAzulClaro}  Configurando OpenWrt como máquina virtual de Proxmox...${vFinColor}"
echo ""

# Configurar red e interfaces
  echo "config interface 'i_loopback'"                > /etc/config/network
  echo "  option proto 'static'"                     >> /etc/config/network
  echo "  option ipaddr '127.0.0.1'"                 >> /etc/config/network
  echo "  option netmask '255.0.0.0'"                >> /etc/config/network
  echo "  option device 'lo'"                        >> /etc/config/network
  echo ""                                            >> /etc/config/network
  echo "config interface 'i_wan'"                    >> /etc/config/network
  echo "  option proto 'static'"                     >> /etc/config/network
  echo "  option gateway '192.168.1.1'"              >> /etc/config/network
  echo "  option ipaddr '192.168.1.251'"             >> /etc/config/network
  echo "  option netmask '255.255.255.0'"            >> /etc/config/network
  echo "  list dns '192.168.1.1'"                    >> /etc/config/network
  echo "  option device 'eth0'"                      >> /etc/config/network
  echo ""                                            >> /etc/config/network
  echo "config interface 'i_lan'"                    >> /etc/config/network
  echo "  option proto 'static'"                     >> /etc/config/network
  echo "  option ipaddr '192.168.252.1'"             >> /etc/config/network
  echo "  option netmask '255.255.255.0'"            >> /etc/config/network
  echo "  list dns '192.168.252.1'"                  >> /etc/config/network
  echo "  option device 'br_lan'"                    >> /etc/config/network
  echo ""                                            >> /etc/config/network
  echo "config interface 'i_iot'"                    >> /etc/config/network
  echo "  option proto 'static'"                     >> /etc/config/network
  echo "  option ipaddr '192.168.254.1'"             >> /etc/config/network
  echo "  option netmask '255.255.255.0'"            >> /etc/config/network
  echo "  list dns '1.1.1.1'"                        >> /etc/config/network
  echo "  option device 'br_iot'"                    >> /etc/config/network
  echo ""                                            >> /etc/config/network
  echo "config interface 'i_inv'"                    >> /etc/config/network
  echo "  option proto 'static'"                     >> /etc/config/network
  echo "  option ipaddr '192.168.253.1'"             >> /etc/config/network
  echo "  option netmask '255.255.255.0'"            >> /etc/config/network
  echo "  list dns '1.1.1.1'"                        >> /etc/config/network
  echo "  option device 'br_inv'"                    >> /etc/config/network
  echo ""                                            >> /etc/config/network
  echo "config device"                               >> /etc/config/network
  echo "  option name 'br_lan'"                      >> /etc/config/network
  echo "  option type 'bridge'"                      >> /etc/config/network
  echo "  option bridge_empty '1'"                   >> /etc/config/network
  echo "  list ports 'eth1'"                         >> /etc/config/network
  echo "  list ports 'eth2'"                         >> /etc/config/network
  echo "  list ports 'eth3'"                         >> /etc/config/network
  echo "  list ports 'eth4'"                         >> /etc/config/network
  echo ""                                            >> /etc/config/network
  echo "config device"                               >> /etc/config/network
  echo "  option name 'br_iot'"                      >> /etc/config/network
  echo "  option type 'bridge'"                      >> /etc/config/network
  echo "  option bridge_empty '1'"                   >> /etc/config/network
  echo ""                                            >> /etc/config/network
  echo "config device"                               >> /etc/config/network
  echo "  option name 'br_inv'"                      >> /etc/config/network
  echo "  option type 'bridge'"                      >> /etc/config/network
  echo "  option bridge_empty '1'"                   >> /etc/config/network
  echo ""                                            >> /etc/config/network

# Configurar cortafuegos

  # defaults
    echo "config defaults"                          > /etc/config/firewall
    echo "  option input 'DROP'"                   >> /etc/config/firewall
    echo "  option output 'DROP'"                  >> /etc/config/firewall
    echo "  option forward 'DROP'"                 >> /etc/config/firewall
    echo "  option synflood_protect '1'"           >> /etc/config/firewall
    echo "  option drop_invalid '1'"               >> /etc/config/firewall

  # zona wan
    echo "config zone"                             >> /etc/config/firewall
    echo "  list network 'i_wan'"                  >> /etc/config/firewall
    echo "  option input 'ACCEPT'"                 >> /etc/config/firewall
    echo "  option output 'ACCEPT'"                >> /etc/config/firewall
    echo "  option forward 'DROP'"                 >> /etc/config/firewall
    echo "  option name 'z_wan'"                   >> /etc/config/firewall
    echo "  option masq '1'"                       >> /etc/config/firewall
    echo "  option mtu_fix '1' "                   >> /etc/config/firewall

  # zona lan
    echo "config zone"                             >> /etc/config/firewall
    echo "  list network 'i_lan'"                  >> /etc/config/firewall
    echo "  list device 'br_lan'"                  >> /etc/config/firewall
    echo "  option input 'DROP'"                   >> /etc/config/firewall
    echo "  option output 'DROP'"                  >> /etc/config/firewall
    echo "  option forward 'DROP'"                 >> /etc/config/firewall
    echo "  option name 'z_lan'"                   >> /etc/config/firewall

  # zona invitados
    echo "config zone"                             >> /etc/config/firewall
    echo "  list network 'i_inv'"                  >> /etc/config/firewall
    echo "  list device 'br_inv'"                  >> /etc/config/firewall
    echo "  option input 'DROP'"                   >> /etc/config/firewall
    echo "  option output 'DROP'"                  >> /etc/config/firewall
    echo "  option forward 'DROP'"                 >> /etc/config/firewall
    echo "  option name 'z_inv'"                   >> /etc/config/firewall

  # zona iot
    echo "config zone"                             >> /etc/config/firewall
    echo "  list network 'i_iot'"                  >> /etc/config/firewall
    echo "  list device 'br_iot'"                  >> /etc/config/firewall
    echo "  option input 'DROP'"                   >> /etc/config/firewall
    echo "  option output 'DROP'"                  >> /etc/config/firewall
    echo "  option forward 'DROP'"                 >> /etc/config/firewall
    echo "  option name 'z_iot'"                   >> /etc/config/firewall

  # Forwarding LAN hacia WAN
    echo ""                                        >> /etc/config/firewall
    echo "config forwarding"                       >> /etc/config/firewall
    echo "  option src 'z_lan'"                    >> /etc/config/firewall
    echo "  option dest 'z_wan'"                   >> /etc/config/firewall

  # Forwarding IOT hacia WAN
    echo ""                                        >> /etc/config/firewall
    echo "config forwarding"                       >> /etc/config/firewall
    echo "  option src 'z_iot'"                    >> /etc/config/firewall
    echo "  option dest 'z_wan'"                   >> /etc/config/firewall

  # Forwarding INV hacia WAN
    echo ""                                        >> /etc/config/firewall
    echo "config forwarding"                       >> /etc/config/firewall
    echo "  option src 'z_inv'"                    >> /etc/config/firewall
    echo "  option dest 'z_wan'"                   >> /etc/config/firewall

  # Permitir LUCI desde WAN
    echo ""                                        >> /etc/config/firewall
    echo "config rule"                             >> /etc/config/firewall
    echo "  list proto 'tcp'"                      >> /etc/config/firewall
    echo "  option name 'Permitir-LUCI-desde-WAN'" >> /etc/config/firewall
    echo "  option src 'z_wan'"                    >> /etc/config/firewall
    echo "  option dest_port '80'"                 >> /etc/config/firewall
    echo "  option target 'ACCEPT'"                >> /etc/config/firewall

  # Permitir SSH desde WAN
    echo ""                                        >> /etc/config/firewall
    echo "config rule"                             >> /etc/config/firewall
    echo "  list proto 'tcp'"                      >> /etc/config/firewall
    echo "  option name 'Permitir-SSH-dede-WAN'"   >> /etc/config/firewall
    echo "  option src 'z_wan'"                    >> /etc/config/firewall
    echo "  option dest_port '22'"                 >> /etc/config/firewall
    echo "  option target 'ACCEPT'"                >> /etc/config/firewall

  # Permitir ping desde WAN
    echo ""                                        >> /etc/config/firewall
    echo "config rule"                             >> /etc/config/firewall
    echo "  list proto 'icmp'"                     >> /etc/config/firewall
    echo "  option name 'Permitir-Ping-desde-WAN'" >> /etc/config/firewall
    echo "  option src 'z_wan'"                    >> /etc/config/firewall
    echo "  option family 'ipv4'"                  >> /etc/config/firewall
    echo "  option icmp_type 'echo-request'"       >> /etc/config/firewall
    echo "  option target 'ACCEPT'"                >> /etc/config/firewall

  # Permitir DHCP desde WAN
    echo ""                                        >> /etc/config/firewall
    echo "config rule"                             >> /etc/config/firewall
    echo "  list proto 'udp'"                      >> /etc/config/firewall
    echo "  option name 'Permitir-DHCP-desde-WAN'" >> /etc/config/firewall
    echo "  option src 'z_wan'"                    >> /etc/config/firewall
    echo "  option family 'ipv4'"                  >> /etc/config/firewall
    echo "  option dest_port '68'"                 >> /etc/config/firewall
    echo "  option target 'ACCEPT'"                >> /etc/config/firewall

  # Permitir DHCP desde IOT
    echo ""                                        >> /etc/config/firewall
    echo "config rule"                             >> /etc/config/firewall
    echo "  list proto 'udp'"                      >> /etc/config/firewall
    echo "  option name 'Permitir-DHCP-desde-IOT'" >> /etc/config/firewall
    echo "  option src 'z_wan'"                    >> /etc/config/firewall
    echo "  option family 'ipv4'"                  >> /etc/config/firewall
    echo "  option dest_port '68'"                 >> /etc/config/firewall
    echo "  option target 'ACCEPT'"                >> /etc/config/firewall
    echo "  option enabled '0'"                    >> /etc/config/firewall

# Configurar WiFi
  #echo "config wifi-device 'radio0'"                           > /etc/config/wireless
  #echo "  option type 'mac80211'"                             >> /etc/config/wireless
  #echo "  option path 'pci0000:00/0000:00:1c.2/0000:03:00.0'" >> /etc/config/wireless
  #echo "  option band '2g'"                                   >> /etc/config/wireless
  #echo "  option htmode 'HT20'"                               >> /etc/config/wireless
  #echo "  option channel 'auto'"                              >> /etc/config/wireless
  #echo "  option cell_density '0'"                            >> /etc/config/wireless
  #echo "  option country 'ES'"                                >> /etc/config/wireless
  #echo ""                                                     >> /etc/config/wireless
  #echo "config wifi-device 'radio1'"                          >> /etc/config/wireless
  #echo "  option type 'mac80211'"                             >> /etc/config/wireless
  #echo "  option path 'pci0000:00/0000:00:1c.3/0000:04:00.0'" >> /etc/config/wireless
  #echo "  option band '5g'"                                   >> /etc/config/wireless
  #echo "  option htmode 'VHT80'"                              >> /etc/config/wireless
  #echo "  option channel 'auto'"                              >> /etc/config/wireless
  #echo "  option cell_density '0'"                            >> /etc/config/wireless
  #echo "  option country 'ES'"                                >> /etc/config/wireless
  echo ""                                                     >> /etc/config/wireless
  echo "config wifi-iface 'default_radio0'"                   >> /etc/config/wireless
  echo "  option ifname 'wlan0'"                              >> /etc/config/wireless
  echo "  option device 'radio0'"                             >> /etc/config/wireless
  echo "  option mode 'ap'"                                   >> /etc/config/wireless
  echo "  option ssid 'OpenWrt'"                              >> /etc/config/wireless
  echo "  option encryption 'sae-mixed'"                      >> /etc/config/wireless
  echo "  option key 'Conectar0'"                             >> /etc/config/wireless
  echo "  option isolate '0'"                                 >> /etc/config/wireless
  echo "  option network 'i_lan'"                             >> /etc/config/wireless
  echo "  option disabled '0'"                                >> /etc/config/wireless
  echo ""                                                     >> /etc/config/wireless
  echo "config wifi-iface 'default_radio1'"                   >> /etc/config/wireless
  echo "  option ifname 'wlan1'"                              >> /etc/config/wireless
  echo "  option device 'radio1'"                             >> /etc/config/wireless
  echo "  option mode 'ap'"                                   >> /etc/config/wireless
  echo "  option ssid 'OpenWrt'"                              >> /etc/config/wireless
  echo "  option encryption 'sae-mixed'"                      >> /etc/config/wireless
  echo "  option key 'Conectar0'"                             >> /etc/config/wireless
  echo "  option isolate '0'"                                 >> /etc/config/wireless
  echo "  option network 'i_lan'"                             >> /etc/config/wireless
  echo "  option disabled '0'"                                >> /etc/config/wireless
  echo ""                                                     >> /etc/config/wireless
  echo "config wifi-iface 'inv_radio0'"                       >> /etc/config/wireless
  echo "  option ifname 'wlan0.1'"                            >> /etc/config/wireless
  echo "  option device 'radio0'"                             >> /etc/config/wireless
  echo "  option mode 'ap'"                                   >> /etc/config/wireless
  echo "  option ssid 'Invitados'"                            >> /etc/config/wireless
  echo "  option encryption 'sae-mixed'"                      >> /etc/config/wireless
  echo "  option key 'Conectar0'"                             >> /etc/config/wireless
  echo "  option isolate '0'"                                 >> /etc/config/wireless
  echo "  option network 'i_inv'"                             >> /etc/config/wireless
  echo "  option disabled '0'"                                >> /etc/config/wireless
  echo ""                                                     >> /etc/config/wireless
  echo "config wifi-iface 'inv_radio1'"                       >> /etc/config/wireless
  echo "  option ifname 'wlan1.1'"                            >> /etc/config/wireless
  echo "  option device 'radio1'"                             >> /etc/config/wireless
  echo "  option mode 'ap'"                                   >> /etc/config/wireless
  echo "  option ssid 'Invitados'"                            >> /etc/config/wireless
  echo "  option encryption 'sae-mixed'"                      >> /etc/config/wireless
  echo "  option key 'Conectar0'"                             >> /etc/config/wireless
  echo "  option isolate '0'"                                 >> /etc/config/wireless
  echo "  option network 'i_inv'"                             >> /etc/config/wireless
  echo "  option disabled '0'"                                >> /etc/config/wireless
  echo ""                                                     >> /etc/config/wireless
  echo "config wifi-iface 'iot_radio0'"                       >> /etc/config/wireless
  echo "  option ifname 'wlan0.2'"                            >> /etc/config/wireless
  echo "  option device 'radio0'"                             >> /etc/config/wireless
  echo "  option mode 'ap'"                                   >> /etc/config/wireless
  echo "  option ssid 'IoT'"                                  >> /etc/config/wireless
  echo "  option encryption 'sae-mixed'"                      >> /etc/config/wireless
  echo "  option key 'Conectar0'"                             >> /etc/config/wireless
  echo "  option isolate '0'"                                 >> /etc/config/wireless
  echo "  option network 'i_iot'"                             >> /etc/config/wireless
  echo "  option disabled '0'"                                >> /etc/config/wireless
  echo ""                                                     >> /etc/config/wireless
  echo "config wifi-iface 'iot_radio1'"                       >> /etc/config/wireless
  echo "  option ifname 'wlan1.2'"                            >> /etc/config/wireless
  echo "  option device 'radio1'"                             >> /etc/config/wireless
  echo "  option mode 'ap'"                                   >> /etc/config/wireless
  echo "  option ssid 'IoT'"                                  >> /etc/config/wireless
  echo "  option encryption 'sae-mixed'"                      >> /etc/config/wireless
  echo "  option key 'Conectar0'"                             >> /etc/config/wireless
  echo "  option isolate '0'"                                 >> /etc/config/wireless
  echo "  option network 'i_iot'"                             >> /etc/config/wireless
  echo "  option disabled '0'"                                >> /etc/config/wireless

# DHCP

  # dnsmasq
    echo "config dnsmasq"                                             > /etc/config/dhcp
    echo "  option domainneeded '1'"                                 >> /etc/config/dhcp
    echo "  option boguspriv '1'"                                    >> /etc/config/dhcp
    echo "  option filterwin2k '0'"                                  >> /etc/config/dhcp
    echo "  option localise_queries '1'"                             >> /etc/config/dhcp
    echo "  option rebind_protection '1'"                            >> /etc/config/dhcp
    echo "  option rebind_localhost '1'"                             >> /etc/config/dhcp
    echo "  option local '/lan/'"                                    >> /etc/config/dhcp
    echo "  option domain 'lan'"                                     >> /etc/config/dhcp
    echo "  option expandhosts '1'"                                  >> /etc/config/dhcp
    echo "  option nonegcache '0'"                                   >> /etc/config/dhcp
    echo "  option authoritative '1'"                                >> /etc/config/dhcp
    echo "  option readethers '1'"                                   >> /etc/config/dhcp
    echo "  option leasefile '/tmp/dhcp.leases'"                     >> /etc/config/dhcp
    echo "  option resolvfile '/tmp/resolv.conf.d/resolv.conf.auto'" >> /etc/config/dhcp
    echo "  option nowildcard '1'"                                   >> /etc/config/dhcp
    echo "  option localservice '1'"                                 >> /etc/config/dhcp
    echo "  option ednspacket_max '1232'"                            >> /etc/config/dhcp
    echo "  option confdir '/tmp/dnsmasq.d'"                         >> /etc/config/dhcp
    echo "  option secuential_ip '1'"                                >> /etc/config/dhcp

  # odhcpd
    echo "config odhcpd 'odhcpd'"                                    >> /etc/config/dhcp
    echo "  option maindhcp '0'"                                     >> /etc/config/dhcp
    echo "  option leasefile '/tmp/hosts/odhcpd'"                    >> /etc/config/dhcp
    echo "  option leasetrigger '/usr/sbin/odhcpd-update'"           >> /etc/config/dhcp
    echo "  option loglevel '4'"                                     >> /etc/config/dhcp

  # DHCP en i_wan
    echo "config dhcp 'i_wan'"                                       >> /etc/config/dhcp
    echo "  option interface 'i_wan'"                                >> /etc/config/dhcp
    echo "  option ignore '1'"                                       >> /etc/config/dhcp

  # DHCP en interfaz i_lan
    echo "config dhcp 'i_lan'"                                       >> /etc/config/dhcp
    echo "  list ra_flags 'none'"                                    >> /etc/config/dhcp
    echo "  option interface 'i_lan'"                                >> /etc/config/dhcp
    echo "  option start '100'"                                      >> /etc/config/dhcp
    echo "  option limit '199'"                                      >> /etc/config/dhcp
    echo "  option leasetime '12h'"                                  >> /etc/config/dhcp
    echo "  option force '1'"                                        >> /etc/config/dhcp

  # DHCP en interfaz i_inv
    echo "config dhcp 'i_inv'"                                       >> /etc/config/dhcp
    echo "  list ra_flags 'none'"                                    >> /etc/config/dhcp
    echo "  option interface 'i_inv'"                                >> /etc/config/dhcp
    echo "  option start '100'"                                      >> /etc/config/dhcp
    echo "  option limit '199'"                                      >> /etc/config/dhcp
    echo "  option leasetime '12h'"                                  >> /etc/config/dhcp
    echo "  option force '1'"                                        >> /etc/config/dhcp

  # DHCP en interfaz i_iot
    echo "config dhcp 'i_iot'"                                       >> /etc/config/dhcp
    echo "  list ra_flags 'none'"                                    >> /etc/config/dhcp
    echo "  option interface 'i_iot'"                                >> /etc/config/dhcp
    echo "  option start '100'"                                      >> /etc/config/dhcp
    echo "  option limit '199'"                                      >> /etc/config/dhcp
    echo "  option leasetime '12h'"                                  >> /etc/config/dhcp
    echo "  option force '1'"                                        >> /etc/config/dhcp

# Configurar AdBlock
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
  echo "  list adb_repiface 'br_lan'"                >> /etc/config/adblock
  echo "  list adb_enabled '1'"                      >> /etc/config/adblock

# Apagar
  echo ""
  echo -e "${ColorAzul}    Apagando OpenWrt para que se puedan asignar las tarjetas...${FinColor}"
  echo ""
  poweroff

