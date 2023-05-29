#!/bin/sh

# Determinar el dispositivo de la partición overlay actual
  vDispPartOverlay="$(sed -n -e "/\s\/overlay\s.*$/s///p" /etc/mtab)"

# Configurar fstab para montar rootfs_data en otra carpeta
  uci -q delete fstab.rwm
  uci set fstab.rwm="mount"
  uci set fstab.rwm.device="${vDispPartOverlay}"
  uci set fstab.rwm.target="/rwm"
  uci commit fstab

# Obtener el UUID de la que va a ser la nueva partición overlay
  #vNuevaPartOverlay=$(blkid | grep ext4 | cut -d':' -f1 | head -n1)
  vNuevoDispOverlay=$(blkid | grep ext4 | cut -d':' -f1 | tail -n1)
  echo ""
  echo "  El nuevo dispositivo overlay será $vNuevoDispOverlay."
  echo ""
  vNuevoUUID=$(blkid | grep $vNuevoDispOverlay | cut -d'"' -f2)
  echo ""
  echo "    Su UUID es $vNuevoUUID."
  echo ""

# Borrar la configuración overlay actual de fstab
  uci -q delete fstab.overlay

# Crear una nueva configuración overlay en fstab en base al UUID obtenido antes
  uci set fstab.overlay="mount"
  uci set fstab.overlay.uuid="${vNuevoUUID}"
  uci set fstab.overlay.target="/overlay"
  uci commit fstab

# Transferir datos
  mkdir -p /mnt/NuevoDispositivoOverlay
  mount $vNuevoDispOverlay /mnt/NuevoDispositivoOverlay
  tar -C /overlay -cvf - . | tar -C /mnt/NuevoDispositivoOverlay -xf -

# Reiniciar
  reboot

