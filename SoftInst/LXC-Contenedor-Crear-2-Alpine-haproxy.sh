#!/bin/sh

vCarpetaLXC='/mnt/nvme/lxc'

cNombreDelContenedor='haproxy'
vAlpineVers='3.23'
vAlpineArch='arm64'

# Crear el contenedor con la última rama estable de Alpine
rm -rf "$vCarpetaLXC"/containers/"$cNombreDelContenedor"
lxc-create -n "$cNombreDelContenedor" -t download -- --dist alpine --release "$vAlpineVers" --arch "$vAlpineArch"

# Configurar la red del contenedor en openwrt
  echo 'lxc.net.0.ipv4.address = 10.10.4.2/24' >> /mnt/nvme/lxc/containers/"$cNombreDelContenedor"/config
  echo 'lxc.net.0.ipv4.gateway = 10.10.4.1'    >> /mnt/nvme/lxc/containers/"$cNombreDelContenedor"/config
# Configurar la red del contenedor en el propio Alpine
  echo 'auto lo'                                      > "$vCarpetaLXC"/containers/"$cNombreDelContenedor"/rootfs/etc/network/interfaces
  echo 'iface lo inet loopback'                      >> "$vCarpetaLXC"/containers/"$cNombreDelContenedor"/rootfs/etc/network/interfaces
  echo ''                                            >> "$vCarpetaLXC"/containers/"$cNombreDelContenedor"/rootfs/etc/network/interfaces
  echo 'auto eth0'                                   >> "$vCarpetaLXC"/containers/"$cNombreDelContenedor"/rootfs/etc/network/interfaces
  echo 'iface eth0 inet static'                      >> "$vCarpetaLXC"/containers/"$cNombreDelContenedor"/rootfs/etc/network/interfaces
  echo '  address 10.10.4.2'                         >> "$vCarpetaLXC"/containers/"$cNombreDelContenedor"/rootfs/etc/network/interfaces
  echo '  netmask 255.255.255.0'                     >> "$vCarpetaLXC"/containers/"$cNombreDelContenedor"/rootfs/etc/network/interfaces
  echo '  gateway 10.10.4.1'                         >> "$vCarpetaLXC"/containers/"$cNombreDelContenedor"/rootfs/etc/network/interfaces
  # Corregir /etc/resolv.conf
    lxc-start -n "$cNombreDelContenedor"
    rm -f                            "$vCarpetaLXC"/containers/"$cNombreDelContenedor"/rootfs/etc/resolv.conf
    echo "nameserver 9.9.9.9"      > "$vCarpetaLXC"/containers/"$cNombreDelContenedor"/rootfs/etc/resolv.conf
  # Preparar contenedor
    lxc-attach -n "$cNombreDelContenedor" -- apk update
    lxc-attach -n "$cNombreDelContenedor" -- apk add openssh-server
    lxc-attach -n "$cNombreDelContenedor" -- sed -i -e 's|#PermitRootLogin prohibit-password|PermitRootLogin yes|g' /etc/ssh/sshd_config
      lxc-attach -n "$cNombreDelContenedor" -- rc-service sshd start
      lxc-attach -n "$cNombreDelContenedor" -- rc-update add sshd default
    lxc-attach -n "$cNombreDelContenedor" -- apk add curl
    lxc-attach -n "$cNombreDelContenedor" -- apk add nano
    lxc-attach -n "$cNombreDelContenedor" -- apk add haproxy
    lxc-stop -n "$cNombreDelContenedor"
  # Conectarse a su terminal
    # lxc-attach -n "$cNombreDelContenedor" -- /bin/sh


# Activar el servicio al arranque
  rc-update add haproxy default
# Arrancarlo o reiniciarlo
  rc-service haproxy restart
# Configurar haproxy
  apk add haproxy
  echo 'global'                                               > /etc/haproxy.cfg
  echo '  log /dev/log local0'                               >> /etc/haproxy.cfg
  echo '  maxconn 4096'                                      >> /etc/haproxy.cfg
  echo '  user haproxy'                                      >> /etc/haproxy.cfg
  echo '  group haproxy'                                     >> /etc/haproxy.cfg
  echo '  daemon'                                            >> /etc/haproxy.cfg
  echo ''                                                    >> /etc/haproxy.cfg
  echo 'defaults'                                            >> /etc/haproxy.cfg
  echo '  log global'                                        >> /etc/haproxy.cfg
  echo '  timeout connect 5s'                                >> /etc/haproxy.cfg
  echo '  timeout client 60s'                                >> /etc/haproxy.cfg
  echo '  timeout server 60s'                                >> /etc/haproxy.cfg
  echo ''                                                    >> /etc/haproxy.cfg
  echo 'frontend fe_http'                                    >> /etc/haproxy.cfg
  echo '  bind 0.0.0.0:80'                                   >> /etc/haproxy.cfg
  echo '  mode tcp'                                          >> /etc/haproxy.cfg
  echo '  option tcplog'                                     >> /etc/haproxy.cfg
  echo '  default_backend be_web_http'                       >> /etc/haproxy.cfg
  echo ''                                                    >> /etc/haproxy.cfg
  echo 'frontend fe_https'                                   >> /etc/haproxy.cfg
  echo '  bind 0.0.0.0:443'                                  >> /etc/haproxy.cfg
  echo '  mode tcp'                                          >> /etc/haproxy.cfg
  echo '  option tcplog'                                     >> /etc/haproxy.cfg
  echo '  default_backend be_web_https'                      >> /etc/haproxy.cfg
  echo ''                                                    >> /etc/haproxy.cfg
  echo ''                                                    >> /etc/haproxy.cfg
  echo 'backend be_web_http'                                 >> /etc/haproxy.cfg
  echo '  mode tcp'                                          >> /etc/haproxy.cfg
  echo '  server web1 192.168.4.2:11080 check send-proxy-v2' >> /etc/haproxy.cfg
  echo ''                                                    >> /etc/haproxy.cfg
  echo 'backend be_web_https'                                >> /etc/haproxy.cfg
  echo '  mode tcp'                                          >> /etc/haproxy.cfg
  echo '  server web1 192.168.4.2:11443 check send-proxy-v2' >> /etc/haproxy.cfg







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
