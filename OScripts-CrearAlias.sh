#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para crear los alias de los o-scripts 
# ----------

# Definir variables de color
  vColorAzul="\033[0;34m"
  vColorAzulClaro="\033[1;34m"
  vColorVerde='\033[1;32m'
  vColorRojo='\033[1;31m'
  vFinColor='\033[0m'

echo ""
echo -e "${vColorAzulClaro}  Creando alias para los o-scripts...${vFinColor}"
echo ""

ln -s /root/scripts/o-scripts/OpenWrt-ActualizarPaquetes.sh   /root/scripts/o-scripts/Alias/aso
ln -s /root/scripts/o-scripts/OScripts-Sincronizar.sh         /root/scripts/o-scripts/Alias/sinos
ln -s /root/scripts/o-scripts/Subred-Inspeccionar.sh          /root/scripts/o-scripts/Alias/is

echo ""
echo -e "${vColorVerde}    Alias creados. Deberías poder ejecutar los o-scripts escribiendo el nombre de su alias.${vFinColor}"
echo ""

