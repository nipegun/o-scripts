#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------
#  Script de NiPeGun para montar la partición EFI de OpenWrt
#-------------------------------------------------------------

mkdir -p /PartEFI/ 2> /dev/null
mount -t auto /dev/sda1 /PartEFI/

