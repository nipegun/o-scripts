#!/bin/sh

vCarpetaLXC='/mnt/nvme/lxc'

vNombreDelContenedor='chirpstack'
vDebianVers='trixie'
vDebianArch='arm64'

# Crear el contenedor con la última versión de Debian
  rm -rf "$vCarpetaLXC"/containers/"$vNombreDelContenedor"
  lxc-create -n "$vNombreDelContenedor" -t download -- --dist debian --release "$vDebianVers" --arch "$vDebianArch"
  echo 'lxc.net.0.ipv4.address = 192.168.4.2/24' >> /mnt/nvme/lxc/containers/"$vNombreDelContenedor"/config
  echo 'lxc.net.0.ipv4.gateway = 192.168.4.1'    >> /mnt/nvme/lxc/containers/"$vNombreDelContenedor"/config
  mkdir -p                         "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/systemd/network
  echo '[Match]'                 > "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/systemd/network/eth0.network
  echo 'Name=eth0'              >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/systemd/network/eth0.network
  echo ''                       >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/systemd/network/eth0.network
  echo '[Network]'              >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/systemd/network/eth0.network
  echo 'Address=192.168.4.2/24' >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/systemd/network/eth0.network
  echo 'Gateway=192.168.4.1'    >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/systemd/network/eth0.network
  echo 'DNS=192.168.4.1'        >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/systemd/network/eth0.network
  # Corregir /etc/resolv.conf
    lxc-start -n "$vNombreDelContenedor"
    rm -f                            "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/resolv.conf
    echo "nameserver 9.9.9.9"      > "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/resolv.conf
  # Preparar contenedor
    lxc-attach -n "$vNombreDelContenedor" -- apt-get -y update
    lxc-attach -n "$vNombreDelContenedor" -- apt-get -y install openssh-server
    lxc-attach -n "$vNombreDelContenedor" -- apt-get -y install curl
    lxc-attach -n "$vNombreDelContenedor" -- apt-get -y install nano
    lxc-stop -n "$vNombreDelContenedor"
  # Conectarse a su terminal
    # lxc-attach -n "$vNombreDelContenedor" -- /bin/bash



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
