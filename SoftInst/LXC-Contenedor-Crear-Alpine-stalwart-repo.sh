#!/bin/sh

# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/o-scripts/refs/heads/master/SoftInst/LXC-Contenedor-Crear-Alpine-stalwart-repo.sh | sh

vCarpetaLXC='/mnt/nvme/lxc'

vNombreDelContenedor='stalwart'
vAlpineVers='3.23'
vAlpineArch='arm64'

# Crear el contenedor con la última rama estable de Alpine
  lxc-stop -n "$vNombreDelContenedor"
  rm -rf "$vCarpetaLXC"/containers/"$vNombreDelContenedor"
  lxc-create -n "$vNombreDelContenedor" -t download -- --dist alpine --release "$vAlpineVers" --arch "$vAlpineArch"

# Configurar la red del contenedor en openwrt
  echo 'lxc.net.0.ipv4.address = 10.10.4.3/24' >> /mnt/nvme/lxc/containers/"$vNombreDelContenedor"/config
  echo 'lxc.net.0.ipv4.gateway = 10.10.4.1'    >> /mnt/nvme/lxc/containers/"$vNombreDelContenedor"/config
# Configurar la red del contenedor en el propio Alpine
  echo 'auto lo'                                      > "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/network/interfaces
  echo 'iface lo inet loopback'                      >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/network/interfaces
  echo ''                                            >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/network/interfaces
  echo 'auto eth0'                                   >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/network/interfaces
  echo 'iface eth0 inet static'                      >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/network/interfaces
  echo '  address 10.10.4.3'                         >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/network/interfaces
  echo '  netmask 255.255.255.0'                     >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/network/interfaces
  echo '  gateway 10.10.4.1'                         >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/network/interfaces
# Corregir /etc/resolv.conf
  lxc-start -n "$vNombreDelContenedor"
  rm -f                            "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/resolv.conf
  echo "nameserver 9.9.9.9"      > "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/resolv.conf
# Preparar contenedor
  lxc-attach -n "$vNombreDelContenedor" -- apk update
  lxc-attach -n "$vNombreDelContenedor" -- apk add openssh-server
  lxc-attach -n "$vNombreDelContenedor" -- apk add curl
  lxc-attach -n "$vNombreDelContenedor" -- apk add nano
# Instalar Stalwart Mail Server
    lxc-attach -n "$vNombreDelContenedor" -- apk add --no-cache --repository https://dl-cdn.alpinelinux.org/alpine/edge/community --repository https://dl-cdn.alpinelinux.org/alpine/edge/testing stalwart-mail stalwart-mail-openrc
# Iniciar el servicio
  lxc-attach -n "$vNombreDelContenedor" -- rc-service stalwart-mail start
# Hacer que se inicie al arranque
  lxc-attach -n "$vNombreDelContenedor" -- rc-update add stalwart-mail default
# Mostrar la versión instalada
  lxc-attach -n "$vNombreDelContenedor" -- apk list -I stalwart-mail
# Apagar el contenedor
  lxc-stop -n "$vNombreDelContenedor"
    
# Mostrar mensaje para fin de la instalación
  echo ''
  echo '  Instalación de Stalwart mail Server, finalizada.'
  echo '  Para conectarse a su terminal:'
  echo "    lxc-start -n "$vNombreDelContenedor" "
  echo "    lxc-attach -n "$vNombreDelContenedor" -- /bin/sh"
  echo ''
