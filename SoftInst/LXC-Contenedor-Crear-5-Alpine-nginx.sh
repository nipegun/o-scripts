#!/bin/sh

# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/o-scripts/refs/heads/master/SoftInst/LXC-Contenedor-Crear-4-Alpine-apache2.sh | sh

cCarpetaLXC='/mnt/nvme/lxc'

cNombreDelContenedor='alpine-nginx'
cAlpineVers='3.23'
cAlpineArch='arm64'
cIPv4Contenedor='10.10.4.5'
cMaskCIDR='24'
cMaskOctal='255.255.255.0'
cIPv4Gateway='10.10.4.1'

# Crear el contenedor con la última rama estable de Alpine
  echo ''
  echo '  ### Creando el contenedor'
  lxc-stop -n "$cNombreDelContenedor"
  rm -rf "$cCarpetaLXC"/containers/"$cNombreDelContenedor"
  lxc-create -n "$cNombreDelContenedor" -t download -- --dist alpine --release "$cAlpineVers" --arch "$cAlpineArch"

# Configurar auto-inicio del contendor
  echo ''
  echo '  ### Configurando el auto-inicio del contenedor'
  uci add lxc-auto container
  uci set lxc-auto.@container[-1].name="$cNombreDelContenedor"
  uci set lxc-auto.@container[-1].timeout='60'
  uci commit lxc-auto

# Configurar la red del contenedor en openwrt
  echo "lxc.net.0.ipv4.address = $cIPv4Contenedor/$cMaskCIDR" >> /mnt/nvme/lxc/containers/"$cNombreDelContenedor"/config
  echo "lxc.net.0.ipv4.gateway = $cIPv4Gateway"               >> /mnt/nvme/lxc/containers/"$cNombreDelContenedor"/config
# Configurar la red del contenedor en el propio Alpine
  echo 'auto lo'                     > "$cCarpetaLXC"/containers/"$cNombreDelContenedor"/rootfs/etc/network/interfaces
  echo 'iface lo inet loopback'     >> "$cCarpetaLXC"/containers/"$cNombreDelContenedor"/rootfs/etc/network/interfaces
  echo ''                           >> "$cCarpetaLXC"/containers/"$cNombreDelContenedor"/rootfs/etc/network/interfaces
  echo 'auto eth0'                  >> "$cCarpetaLXC"/containers/"$cNombreDelContenedor"/rootfs/etc/network/interfaces
  echo 'iface eth0 inet static'     >> "$cCarpetaLXC"/containers/"$cNombreDelContenedor"/rootfs/etc/network/interfaces
  echo "  address $cIPv4Contenedor" >> "$cCarpetaLXC"/containers/"$cNombreDelContenedor"/rootfs/etc/network/interfaces
  echo "  netmask $cMaskOctal"      >> "$cCarpetaLXC"/containers/"$cNombreDelContenedor"/rootfs/etc/network/interfaces
  echo "  gateway $cIPv4Gateway"    >> "$cCarpetaLXC"/containers/"$cNombreDelContenedor"/rootfs/etc/network/interfaces
# Corregir /etc/resolv.conf
  lxc-start -n "$cNombreDelContenedor"
  rm -f                            "$cCarpetaLXC"/containers/"$cNombreDelContenedor"/rootfs/etc/resolv.conf
  echo "nameserver 9.9.9.9"      > "$cCarpetaLXC"/containers/"$cNombreDelContenedor"/rootfs/etc/resolv.conf
# Preparar contenedor
  lxc-attach -n "$cNombreDelContenedor" -- apk update
  lxc-attach -n "$cNombreDelContenedor" -- apk add openssh-server
    echo 'root:raizraiz' | lxc-attach -n "$cNombreDelContenedor" -- chpasswd
    lxc-attach -n "$cNombreDelContenedor" -- sed -i -e 's|#PermitRootLogin prohibit-password|PermitRootLogin yes|g' /etc/ssh/sshd_config
    lxc-attach -n "$cNombreDelContenedor" -- rc-service sshd start
    lxc-attach -n "$cNombreDelContenedor" -- rc-update add sshd default
  lxc-attach -n "$cNombreDelContenedor" -- apk add curl
  lxc-attach -n "$cNombreDelContenedor" -- apk add nano
# Instalar apache2
  # Instalar el paquete
    lxc-attach -n "$cNombreDelContenedor" -- apk add nginx
  # Modificar el virtualost por defecto
    lxc-attach -n "$cNombreDelContenedor" -- sh -c "echo 'server {'                          > /etc/nginx/http.d/default.conf"
    lxc-attach -n "$cNombreDelContenedor" -- sh -c "echo '  listen 80 default_server;'      >> /etc/nginx/http.d/default.conf"
    lxc-attach -n "$cNombreDelContenedor" -- sh -c "echo '  listen [::]:80 default_server;' >> /etc/nginx/http.d/default.conf"
    lxc-attach -n "$cNombreDelContenedor" -- sh -c "echo ''                                 >> /etc/nginx/http.d/default.conf"
    lxc-attach -n "$cNombreDelContenedor" -- sh -c "echo '  root /var/lib/nginx/html;'      >> /etc/nginx/http.d/default.conf"
    lxc-attach -n "$cNombreDelContenedor" -- sh -c "echo '  index index.html index.htm;'    >> /etc/nginx/http.d/default.conf"
    lxc-attach -n "$cNombreDelContenedor" -- sh -c "echo ''                                 >> /etc/nginx/http.d/default.conf"
    lxc-attach -n "$cNombreDelContenedor" -- sh -c "echo '  location / {'                   >> /etc/nginx/http.d/default.conf"
    lxc-attach -n "$cNombreDelContenedor" -- sh -c "echo '    try_files \$uri \$uri/ =404;' >> /etc/nginx/http.d/default.conf"
    lxc-attach -n "$cNombreDelContenedor" -- sh -c "echo '  }'                              >> /etc/nginx/http.d/default.conf"
    lxc-attach -n "$cNombreDelContenedor" -- sh -c "echo ''                                 >> /etc/nginx/http.d/default.conf"
    lxc-attach -n "$cNombreDelContenedor" -- sh -c "echo '}'                                >> /etc/nginx/http.d/default.conf"
  # Iniciar el servicio
    lxc-attach -n "$cNombreDelContenedor" -- rc-service nginx start
  # Hacer que se inicie al arranque
    lxc-attach -n "$cNombreDelContenedor" -- rc-update add nginx default
  # Mostrar la versión instalada
    lxc-attach -n "$cNombreDelContenedor" -- apk list -I nginx
  # Apagar el contenedor
    lxc-stop -n "$cNombreDelContenedor"
    
# Mostrar mensaje para fin de la instalación
  echo ''
  echo '  Instalación de nginx, finalizada.'
  echo '    La web está en:'
  echo "      http://$cIPv4Contenedor"
  echo '    La raíz de las páginas webs quedan en:'
  echo '      /var/www/localhost/htdocs/'
  echo '    Para iniciar el contenedor'
  echo "      lxc-start -n "$cNombreDelContenedor" "
  echo '    Para entrar en su terminal:'
  echo "      lxc-attach -n "$cNombreDelContenedor" -- /bin/sh"
  echo ''
