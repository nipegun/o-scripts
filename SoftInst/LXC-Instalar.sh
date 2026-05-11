#!/bin/sh

# Script de NiPeGun para instalar y configurar LXC en OpenWrt

# Actualizar la lista de paquetes disponibles en los repositorios
  apk update

# Instalar lxc para LUCI para que se instalen todas las dependencias con él
  apk add luci-i18n-lxc-es

# Instalar compatibilidad con virtual ethernet para crear una red única para los contenedores
  apk add kmod-veth

# Crear el dispositivo de puente
  uci set network.devbrdmz='device'
  uci set network.devbrdmz.type='bridge'
  uci set network.devbrdmz.name='devbrdmz'
  uci set network.devbrdmz.bridge_empty='1'
  uci commit network
  /etc/init.d/network reload

# Crear la interfaz
  uci set network.intdmz='interface'
  uci set network.intdmz.proto='static'
  uci set network.intdmz.device='devbrdmz'
  uci set network.intdmz.ipaddr='192.168.3.1'
  uci set network.intdmz.netmask='255.255.255.0'
  uci commit network
  /etc/init.d/network reload

# Crear la zona del firewall
  uci add firewall zone
  uci set firewall.@zone[-1].name='zonedmz'
  uci set firewall.@zone[-1].network='intdmz'
  uci set firewall.@zone[-1].input='DROP'
  uci set firewall.@zone[-1].output='ACCEPT'
  uci set firewall.@zone[-1].forward='DROP'
  uci set firewall.@zone[-1].masq='0'
  uci set firewall.@zone[-1].mtu_fix='0'

  uci add firewall forwarding
  uci set firewall.@forwarding[-1].src='zonedmz'
  uci set firewall.@forwarding[-1].dest='wan'

  uci commit firewall
  /etc/init.d/firewall restart

# Crear las reglas del cortafuegos para una web
  uci add firewall redirect
  uci set firewall.@redirect[-1].name='WAN_HTTP_to_DMZ_web1'
  uci set firewall.@redirect[-1].src='wan'
  uci set firewall.@redirect[-1].src_dport='80'
  uci set firewall.@redirect[-1].dest='zonedmz'
  uci set firewall.@redirect[-1].dest_ip='192.168.3.2'
  uci set firewall.@redirect[-1].dest_port='80'
  uci set firewall.@redirect[-1].proto='tcp'
  uci set firewall.@redirect[-1].target='DNAT'

  uci add firewall redirect
  uci set firewall.@redirect[-1].name='WAN_HTTPS_to_DMZ_web1'
  uci set firewall.@redirect[-1].src='wan'
  uci set firewall.@redirect[-1].src_dport='443'
  uci set firewall.@redirect[-1].dest='zonedmz'
  uci set firewall.@redirect[-1].dest_ip='192.168.3.2'
  uci set firewall.@redirect[-1].dest_port='443'
  uci set firewall.@redirect[-1].proto='tcp'
  uci set firewall.@redirect[-1].target='DNAT'

  uci commit firewall
  /etc/init.d/firewall restart

# Configuración de red del LXC
  lxc.net.0.type = veth
  lxc.net.0.link = devbrdmz
  lxc.net.0.flags = up
  lxc.net.0.name = eth0

# Permitir a los contenedores usar el servidor DNS de OpenWrt
  uci add firewall rule
  uci set firewall.@rule[-1].name='Allow-DMZ-DNS'
  uci set firewall.@rule[-1].src='zonedmz'
  uci set firewall.@rule[-1].dest_port='53'
  uci set firewall.@rule[-1].proto='tcp udp'
  uci set firewall.@rule[-1].target='ACCEPT'

  uci commit firewall
  /etc/init.d/firewall restart

# Configurar haproxy
  echo 'global'                                               > /etc/haproxy/haproxy.cfg
  echo '  log /dev/log local0'                               >> /etc/haproxy/haproxy.cfg
  echo '  maxconn 4096'                                      >> /etc/haproxy/haproxy.cfg
  echo '  user haproxy'                                      >> /etc/haproxy/haproxy.cfg
  echo '  group haproxy'                                     >> /etc/haproxy/haproxy.cfg
  echo '  daemon'                                            >> /etc/haproxy/haproxy.cfg
  echo ''                                                    >> /etc/haproxy/haproxy.cfg
  echo 'defaults'                                            >> /etc/haproxy/haproxy.cfg
  echo '  log global'                                        >> /etc/haproxy/haproxy.cfg
  echo '  timeout connect 5s'                                >> /etc/haproxy/haproxy.cfg
  echo '  timeout client 60s'                                >> /etc/haproxy/haproxy.cfg
  echo '  timeout server 60s'                                >> /etc/haproxy/haproxy.cfg
  echo ''                                                    >> /etc/haproxy/haproxy.cfg
  echo 'frontend fe_http'                                    >> /etc/haproxy/haproxy.cfg
  echo '  bind 0.0.0.0:80'                                   >> /etc/haproxy/haproxy.cfg
  echo '  mode http'                                         >> /etc/haproxy/haproxy.cfg
  echo '  option httplog'                                    >> /etc/haproxy/haproxy.cfg
  echo '  default_backend be_web_http'                       >> /etc/haproxy/haproxy.cfg
  echo ''                                                    >> /etc/haproxy/haproxy.cfg
  echo 'backend be_web_http'                                 >> /etc/haproxy/haproxy.cfg
  echo '  mode http'                                         >> /etc/haproxy/haproxy.cfg
  echo '  server web1 192.168.3.2:11080 check send-proxy-v2' >> /etc/haproxy/haproxy.cfg
  echo ''                                                    >> /etc/haproxy/haproxy.cfg
  echo 'frontend fe_https'                                   >> /etc/haproxy/haproxy.cfg
  echo '  bind 0.0.0.0:443'                                  >> /etc/haproxy/haproxy.cfg
  echo '  mode tcp'                                          >> /etc/haproxy/haproxy.cfg
  echo '  option tcplog'                                     >> /etc/haproxy/haproxy.cfg
  echo '  default_backend be_web_https'                      >> /etc/haproxy/haproxy.cfg
  echo ''                                                    >> /etc/haproxy/haproxy.cfg
  echo 'backend be_web_https'                                >> /etc/haproxy/haproxy.cfg
  echo '  mode tcp'                                          >> /etc/haproxy/haproxy.cfg
  echo '  server web1 192.168.3.2:11443 check send-proxy-v2' >> /etc/haproxy/haproxy.cfg
