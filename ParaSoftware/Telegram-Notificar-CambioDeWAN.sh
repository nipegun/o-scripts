#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para notificar el cambio de IP WAN de un servidor Proxmox
#
#  Este script no puede ser ejecutado remotamente. Debe ser ejecutado desde los p-scripts.
#
#  El script contempla la existencia de dos archivos en dos rutas específicas:
#    /root/scripts/Telegram/TokenDelBot.txt (Con el token del bot que enviará el mensaje)
#    /root/scripts/Telegram/IdChat.txt      (Con el id del chat al que enviar el mensaje de Telegram)
# ----------

# Obtener el hostname
  cHostName=$(uci get system.@system[0].hostname)

# Definir fecha de ejecución del script
  cFechaEjecScript=$(date +a%Ym%md%d@%T)

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  cFinColor='\033[0m'

echo ""
echo -e "${cColorAzulClaro}  Notificando la IP pública del router $cHostName...${cFinColor}"
echo ""

# Guardar la IP pública en una variable
  # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
    if [ "$(opkg list-installed | grep curl)" = "" ]; then
      echo ""
      echo "  "
      echo -e "${cColorRojo}  El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      opkg update
      opkg install curl
    fi
  cIPWAN=$(curl -sL ifconfig.me)

# Comprobar si la IP WAN cambia
  if [[ $cIPWAN != "" ]]; then
    # Notificar por Telegram
      cTokenDelBot=$(cat /root/scripts/Telegram/TokenDelBot.txt)
      cIdChat=$(cat /root/scripts/Telegram/IdChat.txt)
      cMensaje="$cFechaEjecScript - El router $cHostName ahora tiene salida a Internet a través de la siguiente IP pública: $cIPWAN."
      /root/scripts/o-scripts/OpenWrt-Telegram-Enviar-Texto.sh  "$cTokenDelBot" "$cIdChat" "$cMensaje"
    # Actualizar este archivo para adaptar a la nueva IP
      sed -i -e 's|$vIPWAN != ""|$vIPWAN != "'"$cIPWAN"'"|g' /root/scripts/o-scripts/OpenWrt-Telegram-Notificar-CambioDeWAN.sh
  fi
