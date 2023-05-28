#!/bin/sh

vTipoMemoria="mmcblk"
vDispoYPart=$(lsblk | grep overlay | cut -d' ' -f1 | cut -d'k' -f2)
vPartOverlay="/dev/$vTipoMemoria$vDispoYPart"

# Comprobar si está instalado parted

# Mostrar información de la partición
  parted /dev/$vPartOverlay print

