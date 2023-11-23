#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para enviar SMS mediante la terminal de OpenWrt
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/o-scripts/master/MSMS-Enviar.sh | sed 's/xxxxxxxxx/NumeroDeMovilAlQueEnviar/g' | sed 's/xxx/TextoAEnviar/g'| sh
# ----------

# Definir variables
  vConsolaModem="/dev/ttyUSB2"
  vNumeroDestino="xxxxxxxxx"
  vTextoMensaje="xxx"

# Enviar el mensaje mediante el modem
  echo -e "ATZ\r" > $vConsolaModem
  sleep 1
  echo -e "AT+CMGF=1\r" > $vConsolaModem
  sleep 1
  echo -e "AT+CMGS=\"$vNumeroDestino\"\r" > $vConsolaModem
  sleep 1
  echo -e "$vTextoMensaje\x1A" > $vConsolaModem

