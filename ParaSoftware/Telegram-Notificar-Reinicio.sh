#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para notificar el reinicio de un router OpenWrt
#
#  Este script no puede ser ejecutado remotamente. Debe ser ejecutado desde los o-scripts.
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
echo -e "${cColorAzulClaro}  Notificando por Telegram el reinicio del router $cHostName...${cFinColor}"
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
  cIPWAN=$(curl -s ifconfig.me)

# Notificar por Telegram
  # Comprobar si vIPWAN es una IPv4
    if [[ $cIPWAN =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
      cTokenDelBot=$(cat /root/scripts/Telegram/TokenDelBot.txt)
      cIdChat=$(cat /root/scripts/Telegram/IdChat.txt)
      cMensaje="$cFechaEjecScript - El router $cHostName ha terminado de reiniciarse. Su IP pública es: $cIPWAN."
      /root/scripts/o-scripts/OpenWrt-Telegram-Enviar-Texto.sh  "$cTokenDelBot" "$cIdChat" "$cMensaje"
    else
      cTokenDelBot=$(cat /root/scripts/Telegram/TokenDelBot.txt)
      cIdChat=$(cat /root/scripts/Telegram/IdChat.txt)
      cMensaje="$cFechaEjecScript - El router $cHostName ha terminado de reiniciarse. Todavía no tiene una IP pública."
      /root/scripts/o-scripts/OpenWrt-Telegram-Enviar-Texto.sh  "$cTokenDelBot" "$cIdChat" "$cMensaje"
    fi

