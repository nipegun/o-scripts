#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------
#  Script de NiPeGun para sincronizar los o-scripts
#----------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

# Comprobar si hay conexión a Internet antes de sincronizar los o-scripts
wget -q --tries=10 --timeout=20 --spider https://github.com
  if [[ $? -eq 0 ]]; then
    echo ""
    echo "---------------------------------------------------------"
    echo -e "  ${ColorVerde}Sincronizando los o-scripts con las últimas versiones${FinColor}"
    echo -e "  ${ColorVerde} y descargando nuevos o-scripts si es que existen...${FinColor}"
    echo "---------------------------------------------------------"
    echo ""
    rm /root/scripts/o-scripts -R 2> /dev/null
    mkdir /root/scripts 2> /dev/null
    cd /root/scripts
    git clone --depth=1 https://github.com/nipegun/o-scripts
    mkdir -p /root/scripts/o-scripts/Alias/
    rm /root/scripts/o-scripts/.git -R 2> /dev/null
    find /root/scripts/o-scripts/ -type f -iname "*.sh" -exec chmod +x {} \;
    /root/scripts/o-scripts/OScripts-CrearAlias.sh
    find /root/scripts/o-scripts/Alias/ -type f -exec chmod +x {} \;
    echo ""
    echo "-----------------------------------------"
    echo -e "  ${ColorVerde}o-scripts sincronizados correctamente${FinColor}"
    echo "-----------------------------------------"
    echo ""
  else
    echo ""
    echo "---------------------------------------------------------------------------------------------------"
    echo -e "${ColorRojo}No se pudo iniciar la sincronización de los o-scripts porque no se detectó conexión a Internet.${FinColor}"
    echo "---------------------------------------------------------------------------------------------------"
    echo ""
  fi
