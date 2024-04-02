#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para enviar texto via telegram en OpenWrt
#
#  Este script no puede ser ejecutado remotamente. Debe ser ejecutado desde los o-scripts.
#
#  El script contempla la existencia de dos archivos en dos rutas específicas:
#    /root/scripts/Telegram/TokenDelBot.txt (Con el token del bot que enviará el mensaje)
#    /root/scripts/Telegram/IdChat.txt      (Con el id del chat al que enviar el mensaje de Telegram)
# ----------

# Definir fecha de ejecución del script
  cFechaEjecScript=$(date +a%Ym%md%d@%T)

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  cFinColor='\033[0m'

# Definir el mensaje
  cMensaje="$1"

# Notificar por Telegram
  cTokenDelBot=$(cat /root/scripts/Telegram/TokenDelBot.txt)
  cIdChat=$(cat /root/scripts/Telegram/IdChat.txt)
  wget -q --tries=10 --timeout=20 --spider https://api.telegram.org
    if [[ $? -eq 0 ]]; then
      cTokenDelBot=$(cat /root/scripts/Telegram/TokenDelBot.txt)
      cURL="https://api.telegram.org/bot$cTokenDelBot/sendMessage"
      cIdChat=$(cat /root/scripts/Telegram/IdChat.txt)
      cMensaje="$3"
      curl -sL -X POST $cURL -d chat_id=$cIdChat -d text="$cMensaje" > /dev/null
      echo ""
    else
      echo ""
      echo -e "${cColorRojo}  No se pudo enviar el mensaje porque no se pudo contactar con https://api.telegram.org${cFinColor}"
      echo ""
    fi
