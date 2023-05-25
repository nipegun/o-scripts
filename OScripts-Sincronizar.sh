#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para sincronizar los o-scripts
# ----------

# Definir variables de color
  vColorAzul="\033[0;34m"
  vColorAzulClaro="\033[1;34m"
  vColorVerde='\033[1;32m'
  vColorRojo='\033[1;31m'
  vFinColor='\033[0m'

# Comprobar si hay conexión a Internet antes de sincronizar los o-scripts
  wget -q --tries=10 --timeout=20 --spider https://github.com
  if [[ $? -eq 0 ]]; then
    # Sincronizar los o-scripts
      echo ""
      echo -e "${vColorAzulClaro}  Sincronizando los o-scripts con las últimas versiones y descargando nuevos o-scripts si es que existen...${vFinColor}"
      echo ""
      rm /root/scripts/o-scripts -R 2> /dev/null
      mkdir /root/scripts 2> /dev/null
      cd /root/scripts
      git clone --depth=1 https://github.com/nipegun/o-scripts
      mkdir -p /root/scripts/o-scripts/Alias/
      rm /root/scripts/o-scripts/.git -R 2> /dev/null
      rm /root/scripts/o-scripts/README.md
      find /root/scripts/o-scripts/ -type f -iname "*.sh" -exec chmod +x {} \;
      find /root/scripts/o-scripts/Alias/ -type f -exec chmod +x {} \;
      echo ""
      echo -e "${vColorVerde}    o-scripts sincronizados correctamente${vFinColor}"
      echo ""
    # Crear los alias
      /root/scripts/o-scripts/OScripts-CrearAlias.sh
  else
    echo ""
    echo -e "${vColorRojo}  No se pudo iniciar la sincronización de los o-scripts porque no se detectó conexión a Internet.${vFinColor}"
    echo ""
  fi

