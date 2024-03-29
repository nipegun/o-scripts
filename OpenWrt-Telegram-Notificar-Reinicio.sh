#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para notificar el reinicio de un nodo de PVE
#
#  Este script no puede ser ejecutado remotamente. Debe ser ejecutado desde los p-scripts.
#
#  El script contempla la existencia de dos archivos en dos rutas específicas:
#    /root/scripts/Telegram/TokenDelBot.txt (Con el token del bot que enviará el mensaje)
#    /root/scripts/Telegram/IdChat.txt      (Con el id del chat al que enviar el mensaje de Telegram)
# ----------

vFecha=$(date +%Y/%m/%d@%T)
vHostName=$(uci get system.@system[0].hostname)

# Definir variables de color
  vColorAzul="\033[0;34m"
  vColorAzulClaro="\033[1;34m"
  vColorVerde='\033[1;32m'
  vColorRojo='\033[1;31m'
  vFinColor='\033[0m'

echo ""
echo -e "${vColorAzulClaro}  Notificando por Telegram el reinicio del router $vHostName...${vFinColor}"
echo ""

# Guardar la IP pública en una variable
  # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
    if [ "$(opkg list-installed | grep curl)" = "" ]; then
      echo ""
      echo "  "
      echo -e "${vColorRojo}  El paquete curl no está instalado. Iniciando su instalación...${vFinColor}"
      echo ""
      opkg update
      opkg install curl
    fi
  vIPWAN=$(curl -s ifconfig.me)

# Notificar por Telegram
  # Comprobar si vIPWAN es una IPv4
    if [[ $vIPWAN =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
      vTokenDelBot=$(cat /root/scripts/Telegram/TokenDelBot.txt)
      vIdChat=$(cat /root/scripts/Telegram/IdChat.txt)
      vMensaje="$vFecha - El router $vHostName ha terminado de reiniciarse. Su IP pública es: $vIPWAN."
      /root/scripts/o-scripts/Telegram-EnviarTexto.sh  "$vTokenDelBot" "$vIdChat" "$vMensaje"
    else
      vTokenDelBot=$(cat /root/scripts/Telegram/TokenDelBot.txt)
      vIdChat=$(cat /root/scripts/Telegram/IdChat.txt)
      vMensaje="$vFecha - El router $vHostName ha terminado de reiniciarse. Todavía no tiene una IP pública."
      /root/scripts/o-scripts/Telegram-EnviarTexto.sh  "$vTokenDelBot" "$vIdChat" "$vMensaje"
    fi

