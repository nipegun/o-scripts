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


# Crear el contenedor con la última versión de alpine
  rm -rf "$vCarpetaLXC"/containers/chirpstack
  lxc-create -n debian-trixie -t download -- --dist debian --release trixie --arch arm64
  echo 'lxc.net.0.ipv4.address = 192.168.4.2/24' >> /mnt/nvme/lxc/containers/chirpstack/config
  echo 'lxc.net.0.ipv4.gateway = 192.168.4.1'    >> /mnt/nvme/lxc/containers/chirpstack/config
  # Iniciar el contenedor
    # lxc-start -n debian-trixie
  # Conectarse a su terminal
    # lxc-attach -n debian-trixie -- /bin/bash











# Crear las reglas del cortafuegos para una web
  # HTTP
    uci add firewall redirect
    uci set firewall.@redirect[-1].name='wan > wrt HTTP to web1'
    uci set firewall.@redirect[-1].src=${vNomZonaWAN}
    uci set firewall.@redirect[-1].src_dport='80'
    uci set firewall.@redirect[-1].dest=${vNomZonaNueva}
    uci set firewall.@redirect[-1].dest_ip='192.168.4.2'
    uci set firewall.@redirect[-1].dest_port='80'
    uci set firewall.@redirect[-1].proto='tcp'
    uci set firewall.@redirect[-1].target='DNAT'
  # HTTPS
    uci add firewall redirect
    uci set firewall.@redirect[-1].name='wan > wrt HTTPS to web1'
    uci set firewall.@redirect[-1].src=${vNomZonaWAN}
    uci set firewall.@redirect[-1].src_dport='443'
    uci set firewall.@redirect[-1].dest=${vNomZonaNueva}
    uci set firewall.@redirect[-1].dest_ip='192.168.3.2'
    uci set firewall.@redirect[-1].dest_port='443'
    uci set firewall.@redirect[-1].proto='tcp'
    uci set firewall.@redirect[-1].target='DNAT'
  uci commit firewall
  /etc/init.d/firewall restart





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
  echo '  mode tcp'                                          >> /etc/haproxy/haproxy.cfg
  echo '  option tcplog'                                     >> /etc/haproxy/haproxy.cfg
  echo '  default_backend be_web_http'                       >> /etc/haproxy/haproxy.cfg
  echo ''                                                    >> /etc/haproxy/haproxy.cfg
  echo 'backend be_web_http'                                 >> /etc/haproxy/haproxy.cfg
  echo '  mode tcp'                                          >> /etc/haproxy/haproxy.cfg
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

# Dentro del lxc
  # a2enmod remoteip
  # a2enmod ssl
  # systemctl restart apache2

  echo 'Listen 11080'
  echo ''
  echo '<VirtualHost *:11080>'
  echo '  ServerName ejemplo.com'
  echo ''
  echo '  RemoteIPProxyProtocol On'
  echo ''
  echo '  DocumentRoot /var/www/ejemplo.com/public'
  echo ''
  echo '  <Directory /var/www/ejemplo.com/public>'
  echo '    Require all granted'
  echo '    AllowOverride All'
  echo '  </Directory>'
  echo ''
  echo '  ErrorLog ${APACHE_LOG_DIR}/ejemplo-error.log'
  echo '  CustomLog ${APACHE_LOG_DIR}/ejemplo-access.log combined_realip'
  echo '</VirtualHost>'

  echo 'Listen 11443'
  echo ''
  echo '<VirtualHost *:11443>'
  echo '  ServerName ejemplo.com'
  echo ''
  echo '  RemoteIPProxyProtocol On'
  echo ''
  echo '  SSLEngine on'
  echo '  SSLCertificateFile /etc/letsencrypt/live/ejemplo.com/fullchain.pem'
  echo '  SSLCertificateKeyFile /etc/letsencrypt/live/ejemplo.com/privkey.pem'
  echo ''
  echo '  DocumentRoot /var/www/ejemplo.com/public'
  echo ''
  echo '  <Directory /var/www/ejemplo.com/public>'
  echo '    Require all granted'
  echo '    AllowOverride All'
  echo '  </Directory>'
  echo ''
  echo '  ErrorLog ${APACHE_LOG_DIR}/ejemplo-ssl-error.log'
  echo '  CustomLog ${APACHE_LOG_DIR}/ejemplo-ssl-access.log combined_realip'
  echo '</VirtualHost>'

# Registrar %a, en vez de %h, para mejor logs con remoteip. En /etc/apache2/apache2.conf debería habver algo así
#   LogFormat "%a %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" combined_realip
