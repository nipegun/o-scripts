#!/bin/sh

# Script de NiPeGun para instalar y configurar LXC en OpenWrt

# Actualizar la lista de paquetes disponibles en los repositorios
  apk update

# Instalar lxc para LUCI para que se instalen todas las dependencias con él
  apk add luci-i18n-lxc-es
  apk add mount-utils
  apk add lxc-start
  apk add lxc-stop
  apk add lxc-attach
  apk add lxc-info
  apk add lxc-ls
  apk add lxc-destroy
  apk add lxc-console
  apk add lxc-wait

# Instalar compatibilidad con virtual ethernet para crear una red única para los contenedores
  apk add kmod-veth

# Definir variables
  vNomBaseDispPuente='br-' # Podría ser devbr
  vNomDispPuente='lxc'
  vNomInterfaz='lxc'       # Podría ser intlxc
  vNomZonaNueva="lxc"      # Podría ser zonelxc
  vNomZonaWAN="wan"      # Podría ser zonewan
  vNomZonaLAN="lan"      # Podría ser zonelan

# Crear el dispositivo de puente
  vNomDispPuenteCompleto="${vNomBaseDispPuente}${vNomDispPuente}"
  vSeccionDispPuente="$(uci add network device)"
  uci set network."${vSeccionDispPuente}".type='bridge'
  uci set network."${vSeccionDispPuente}".name="${vNomDispPuenteCompleto}"
  uci set network."${vSeccionDispPuente}".bridge_empty='1'
  uci set network."${vSeccionDispPuente}".ipv6='0'
  uci commit network
  /etc/init.d/network reload

# Crear la interfaz
  uci set network.${vNomInterfaz}='interface'
  uci set network.${vNomInterfaz}.proto='static'
  uci set network.${vNomInterfaz}.device="${vNomDispPuenteCompleto}"
  uci set network.${vNomInterfaz}.ipaddr='192.168.4.1'
  uci set network.${vNomInterfaz}.netmask='255.255.255.0'
  uci set network.${vNomInterfaz}.multipath='off'
  uci set network.${vNomInterfaz}.delegate='0'
  uci commit network
  /etc/init.d/network reload

# Firewall
  # Zona
    uci add firewall zone
    uci set firewall.@zone[-1].name=${vNomZonaNueva}
    uci set firewall.@zone[-1].network=${vNomInterfaz}
    uci set firewall.@zone[-1].input='DROP'
    uci set firewall.@zone[-1].output='ACCEPT'
    uci set firewall.@zone[-1].forward='DROP'
    uci set firewall.@zone[-1].masq='0'
    uci set firewall.@zone[-1].mtu_fix='0'
    uci commit firewall
    /etc/init.d/firewall restart
  # Forwarding
    # De ZonaNueva a WAN
      uci add firewall forwarding
      uci set firewall.@forwarding[-1].src=${vNomZonaNueva}
      uci set firewall.@forwarding[-1].dest=${vNomZonaWAN}
      uci commit firewall
      /etc/init.d/firewall restart
    # De LAN a ZonaNueva
      uci add firewall forwarding
      uci set firewall.@forwarding[-1].src=${vNomZonaLAN}
      uci set firewall.@forwarding[-1].dest=${vNomZonaNueva}
      uci commit firewall
      /etc/init.d/firewall restart
  # Permitir a los contenedores usar el servidor DNS de OpenWrt
    uci add firewall rule
    uci set firewall.@rule[-1].name='Permitir DNS a contenedores'
    uci set firewall.@rule[-1].src=${vNomZonaNueva}
    uci set firewall.@rule[-1].dest_port='53'
    uci set firewall.@rule[-1].proto='tcp udp'
    uci set firewall.@rule[-1].target='ACCEPT'
    uci set firewall.@rule[-1].family='ipv4'
    uci commit firewall
    /etc/init.d/firewall restart

# Configurar LXC para que use la carpeta /mnt/nvme/lxc
  vCarpetaLXC='/mnt/nvme/lxc'
  mkdir -p "${vCarpetaLXC}/containers"
  mkdir -p "${vCarpetaLXC}/cache"
  mkdir -p "${vCarpetaLXC}/log"
  echo "lxc.lxcpath = ${vCarpetaLXC}/containers"     > /etc/lxc/lxc.conf
  echo 'lxc.net.0.type = veth'                       > /etc/lxc/default.conf
  echo "lxc.net.0.link = ${vNomDispPuenteCompleto}" >> /etc/lxc/default.conf
  echo 'lxc.net.0.flags = up'                       >> /etc/lxc/default.conf
  echo 'lxc.net.0.name = eth0'                      >> /etc/lxc/default.conf
  echo 'lxc.net.0.hwaddr = 10:66:6a:xx:xx:xx'       >> /etc/lxc/default.conf
  rm -rf /var/cache/lxc
  ln -s "${vCarpetaLXC}/cache" /var/cache/lxc


# Reenviar todo lo que llega desde zonewan a HAProxy
  # HTTP
    uci add firewall redirect
    uci set firewall.@redirect[-1].name='zonewan > wrt HTTP to haproxy'
    uci set firewall.@redirect[-1].src=${vNomZonaWAN}
    uci set firewall.@redirect[-1].src_dport='80'
    uci set firewall.@redirect[-1].dest=${vNomZonaNueva}
    uci set firewall.@redirect[-1].dest_ip='10.10.4.2'
    uci set firewall.@redirect[-1].dest_port='80'
    uci set firewall.@redirect[-1].proto='tcp'
    uci set firewall.@redirect[-1].target='DNAT'
  # HTTPS
    uci add firewall redirect
    uci set firewall.@redirect[-1].name='zonewan > wrt HTTPS to haproxy'
    uci set firewall.@redirect[-1].src=${vNomZonaWAN}
    uci set firewall.@redirect[-1].src_dport='443'
    uci set firewall.@redirect[-1].dest=${vNomZonaNueva}
    uci set firewall.@redirect[-1].dest_ip='10.10.4.2'
    uci set firewall.@redirect[-1].dest_port='443'
    uci set firewall.@redirect[-1].proto='tcp'
    uci set firewall.@redirect[-1].target='DNAT'
  # 25
    uci add firewall redirect
    uci set firewall.@redirect[-1].name='zonewan > wrt X to haproxy'
    uci set firewall.@redirect[-1].src=${vNomZonaWAN}
    uci set firewall.@redirect[-1].src_dport='25'
    uci set firewall.@redirect[-1].dest=${vNomZonaNueva}
    uci set firewall.@redirect[-1].dest_ip='10.10.4.2'
    uci set firewall.@redirect[-1].dest_port='25'
    uci set firewall.@redirect[-1].proto='tcp'
    uci set firewall.@redirect[-1].target='DNAT'
  # 465
    uci add firewall redirect
    uci set firewall.@redirect[-1].name='zonewan > wrt X to haproxy'
    uci set firewall.@redirect[-1].src=${vNomZonaWAN}
    uci set firewall.@redirect[-1].src_dport='465'
    uci set firewall.@redirect[-1].dest=${vNomZonaNueva}
    uci set firewall.@redirect[-1].dest_ip='10.10.4.2'
    uci set firewall.@redirect[-1].dest_port='465'
    uci set firewall.@redirect[-1].proto='tcp'
    uci set firewall.@redirect[-1].target='DNAT'
  # 587
    uci add firewall redirect
    uci set firewall.@redirect[-1].name='zonewan > wrt X to haproxy'
    uci set firewall.@redirect[-1].src=${vNomZonaWAN}
    uci set firewall.@redirect[-1].src_dport='587'
    uci set firewall.@redirect[-1].dest=${vNomZonaNueva}
    uci set firewall.@redirect[-1].dest_ip='10.10.4.2'
    uci set firewall.@redirect[-1].dest_port='587'
    uci set firewall.@redirect[-1].proto='tcp'
    uci set firewall.@redirect[-1].target='DNAT'
  # 993
    uci add firewall redirect
    uci set firewall.@redirect[-1].name='zonewan > wrt X to haproxy'
    uci set firewall.@redirect[-1].src=${vNomZonaWAN}
    uci set firewall.@redirect[-1].src_dport='993'
    uci set firewall.@redirect[-1].dest=${vNomZonaNueva}
    uci set firewall.@redirect[-1].dest_ip='10.10.4.2'
    uci set firewall.@redirect[-1].dest_port='993'
    uci set firewall.@redirect[-1].proto='tcp'
    uci set firewall.@redirect[-1].target='DNAT'
  # 4190
    uci add firewall redirect
    uci set firewall.@redirect[-1].name='zonewan > wrt X to haproxy'
    uci set firewall.@redirect[-1].src=${vNomZonaWAN}
    uci set firewall.@redirect[-1].src_dport='4190'
    uci set firewall.@redirect[-1].dest=${vNomZonaNueva}
    uci set firewall.@redirect[-1].dest_ip='10.10.4.2'
    uci set firewall.@redirect[-1].dest_port='4190'
    uci set firewall.@redirect[-1].proto='tcp'
    uci set firewall.@redirect[-1].target='DNAT'
  uci commit firewall
  /etc/init.d/firewall restart
  uci commit firewall
  /etc/init.d/firewall restart
