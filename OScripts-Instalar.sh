#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar los o-scripts
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/o-scripts/master/OScripts-Instalar.sh | sh
# ----------

# Definir variables de color
  vColorAzul="\033[0;34m"
  vColorAzulClaro="\033[1;34m"
  vColorVerde='\033[1;32m'
  vColorRojo='\033[1;31m'
  vFinColor='\033[0m'

# Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
  if [ "$(opkg list-installed | grep wget)" = "" ]; then
    echo ""
    echo "  "
    echo -e "${vColorRojo}  El paquete wget no está instalado. Iniciando su instalación...${vFinColor}"
    echo ""
    opkg update
    opkg install wget
  fi

# Comprobar si hay conexión a Internet antes de sincronizar los o-scripts
  # wget -q --tries=10 --timeout=20 --spider https://github.com # (Para openWrt 19)
  wget -q --timeout=20 --spider https://github.com

# Instalación
  if [[ $? -eq 0 ]]; then
    echo ""
    echo -e "${ColorVerde}  Sincronizando los o-scripts con las últimas versiones y descargando nuevos o-scripts si es que existen...${FinColor}"
    echo ""
    rm /root/scripts/o-scripts -R 2> /dev/null
    mkdir /root/scripts 2> /dev/null
    cd /root/scripts
    # Comprobar si el paquete git-http está instalado. Si no lo está, instalarlo.
      if [ "$(opkg list-installed | grep git-http)" = "" ]; then
        echo ""
        echo -e "${vColorRojo}    El paquete git-http no está instalado. Iniciando su instalación...${vFinColor}"
        echo "  "
        echo ""
        opkg update
        opkg install git-http
      fi
    git clone --depth=1 https://github.com/nipegun/o-scripts
    rm /root/scripts/o-scripts/.git -R 2> /dev/null
    rm /root/scripts/o-scripts/README.md
    find /root/scripts/o-scripts/ -type f -iname "*.sh" -exec chmod +x {} \;
    echo ""
    echo -e "${vColorVerde}    o-scripts sincronizados correctamente.${vFinColor}"
    echo ""
    # Crear los alias
      mkdir -p /root/scripts/o-scripts/Alias/
      /root/scripts/o-scripts/OScripts-CrearAlias.sh
      find /root/scripts/o-scripts/Alias/ -type f -exec chmod +x {} \;

  else

    echo ""
    echo -e "${vColorRojo}  No se pudo iniciar la sincronización de los o-scripts porque no se detectó conexión a Internet.  ${vFinColor}"
    echo ""

  fi

