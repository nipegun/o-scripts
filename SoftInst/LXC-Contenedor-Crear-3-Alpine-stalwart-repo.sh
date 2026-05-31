#!/bin/sh

# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/o-scripts/refs/heads/master/SoftInst/LXC-Contenedor-Crear-3-Alpine-stalwart-repo.sh | sh

vCarpetaLXC='/mnt/nvme/lxc'

cNombreDelContenedor='stalwart'
vAlpineVers='3.23'
vAlpineArch='arm64'

# Crear el contenedor con la última rama estable de Alpine
  lxc-stop -n "$cNombreDelContenedor"
  rm -rf "$vCarpetaLXC"/containers/"$cNombreDelContenedor"
  lxc-create -n "$cNombreDelContenedor" -t download -- --dist alpine --release "$vAlpineVers" --arch "$vAlpineArch"

# Configurar la red del contenedor en openwrt
  echo 'lxc.net.0.ipv4.address = 10.10.4.3/24' >> /mnt/nvme/lxc/containers/"$cNombreDelContenedor"/config
  echo 'lxc.net.0.ipv4.gateway = 10.10.4.1'    >> /mnt/nvme/lxc/containers/"$cNombreDelContenedor"/config
# Configurar la red del contenedor en el propio Alpine
  echo 'auto lo'                                      > "$vCarpetaLXC"/containers/"$cNombreDelContenedor"/rootfs/etc/network/interfaces
  echo 'iface lo inet loopback'                      >> "$vCarpetaLXC"/containers/"$cNombreDelContenedor"/rootfs/etc/network/interfaces
  echo ''                                            >> "$vCarpetaLXC"/containers/"$cNombreDelContenedor"/rootfs/etc/network/interfaces
  echo 'auto eth0'                                   >> "$vCarpetaLXC"/containers/"$cNombreDelContenedor"/rootfs/etc/network/interfaces
  echo 'iface eth0 inet static'                      >> "$vCarpetaLXC"/containers/"$cNombreDelContenedor"/rootfs/etc/network/interfaces
  echo '  address 10.10.4.3'                         >> "$vCarpetaLXC"/containers/"$cNombreDelContenedor"/rootfs/etc/network/interfaces
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
# Instalar Stalwart Mail Server
    lxc-attach -n "$cNombreDelContenedor" -- apk add --no-cache --repository https://dl-cdn.alpinelinux.org/alpine/edge/community --repository https://dl-cdn.alpinelinux.org/alpine/edge/testing stalwart-mail stalwart-mail-openrc
# Iniciar el servicio
  lxc-attach -n "$cNombreDelContenedor" -- rc-service stalwart-mail start
# Hacer que se inicie al arranque
  lxc-attach -n "$cNombreDelContenedor" -- rc-update add stalwart-mail default
# Mostrar la versión instalada
  lxc-attach -n "$cNombreDelContenedor" -- apk list -I stalwart-mail
# Apagar el contenedor
  lxc-stop -n "$cNombreDelContenedor"
    
# Mostrar mensaje para fin de la instalación
  echo ''
  echo '  Instalación de Stalwart mail Server, finalizada.'
  echo '  Para conectarse a su terminal:'
  echo "    lxc-start -n "$cNombreDelContenedor" "
  echo "    lxc-attach -n "$cNombreDelContenedor" -- /bin/sh"
  echo ''
