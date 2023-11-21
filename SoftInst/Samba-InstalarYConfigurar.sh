#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar netdata en OpenWrt
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/o-scripts/master/SoftInst/NetData-InstalarYConfigurar.sh | sed 's-usuariox-NuevoNombreDeUsuario-g' | sh 
# ----------

# Actualizar la lista de paquetes disponibles en los repositorios
  echo ""
  echo "  Actualizando la lista de paquetes disponibles en los repositorios..."
  echo ""
  opkg update

# Instalar los paquetes de Samba
  echo ""
  echo "  Instalando los paquetes de Samba..."
  echo ""
  opkg install luci-i18n-samba4-es

# Instalar el paquete para agregar usuarios al sistema
  echo ""
  echo "  Instalando el paquete para agregar usuarios al sistema..."
  echo ""
  opkg install shadow-useradd

# Agregar el primer usuario
  echo ""
  echo "  Agregando el primer usuario..."
  echo ""
  useradd -r -s /bin/false usuariox

# Crear la contraseña Samba para el primer usuario
  echo ""
  echo "  Creando la contraseña Samba para el usuario recién creado..."
  echo ""
  smbpasswd -a usuariox

