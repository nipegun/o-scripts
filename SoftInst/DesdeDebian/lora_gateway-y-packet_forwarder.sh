#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para preparar los paquetes lora_gateway y packet_forwarder en Debian para OpenWrt
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL x | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL x | sed 's-sudo--g' | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' x | bash
#
# Ejecución remota con parámetros:
#   curl -sL x | bash -s Parámetro1 Parámetro2
#
# Bajar y editar directamente el archivo en nano
#   curl -sL x | nano -
# ----------


vOpenWrt='24.10.2'
vTarget='mediatek/filogic'

# Instalar dependencias
  sudo apt -y update
  sudo apt -y install build-essential
  sudo apt -y install libncurses5-dev
  sudo apt -y install gawk
  sudo apt -y install git
  sudo apt -y install unzip
  sudo apt -y install file
  sudo apt -y install wget
  sudo apt -y install python3
  sudo apt -y install swig


# Descargar y preparar el SDK
  cd ~
  rm -rf ~/openwrt-sdk
  mkdir -p ~/openwrt-sdk
  cd ~/openwrt-sdk
  vNombreDelArchivo=$(curl -sL https://downloads.openwrt.org/releases/"$vOpenWrt"/targets/"$vTarget"/ | sed 's->->\n-g' | grep href | grep sdk | grep musl | cut -d'"' -f2)
  wget https://downloads.openwrt.org/releases/"$vOpenWrt"/targets/mediatek/filogic/"$vNombreDelArchivo"
  tar xvf "$vNombreDelArchivo"
  vNombreDeLaCarpeta=$(echo "$vNombreDelArchivo" | sed 's-.tar.zst--g')
  cd "$vNombreDeLaCarpeta"

# Clonar los repositorios del forwarder
  cd package
  git clone  --depth 1 --branch master https://github.com/kersing/lora_gateway.git
  git clone  --depth 1 --branch master https://github.com/kersing/packet_forwarder.git

# Crear Makefile para lora_gateway
  cd lora_gateway
  # Obtener el commit
    vHashDelMaster=$(git ls-remote https://github.com/kersing/lora_gateway.git | grep master | awk '{print $1}')
  # Obtener el pkg version
    vPKGversion=$(git show -s --format=%cs $vHashDelMaster)
  echo 'include $(TOPDIR)/rules.mk'                                                  > Makefile
  echo ''                                                                           >> Makefile
  echo 'PKG_NAME:=lora_gateway'                                                     >> Makefile
  echo "PKG_VERSION:=$vPKGversion"                                                  >> Makefile
  echo 'PKG_RELEASE:=1'                                                             >> Makefile
  echo ''                                                                           >> Makefile
  echo 'PKG_SOURCE_PROTO:=git'                                                      >> Makefile
  echo 'PKG_SOURCE_URL:=https://github.com/kersing/lora_gateway.git'                >> Makefile
  echo "PKG_SOURCE_VERSION:=$vHashDelMaster"                                        >> Makefile
  echo 'PKG_MIRROR_HASH:=skip'                                                      >> Makefile
  echo ''                                                                           >> Makefile
  echo 'PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)'                              >> Makefile
  echo 'PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz'                              >> Makefile
  echo 'PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_SOURCE_SUBDIR)'                           >> Makefile
  echo ''                                                                           >> Makefile
  echo 'include $(INCLUDE_DIR)/package.mk'                                          >> Makefile
  echo ''                                                                           >> Makefile
  echo 'define Package/lora_gateway'                                                >> Makefile
  echo -e '\tSECTION:=net'                                                          >> Makefile
  echo -e '\tCATEGORY:=Network'                                                     >> Makefile
  echo -e '\tTITLE:=LoRa Gateway HAL for Semtech SX1301 (UART/SPI)'                 >> Makefile
  echo -e '\tDEPENDS:=+libpthread +librt'                                           >> Makefile
  echo 'endef'                                                                      >> Makefile
  echo ''                                                                           >> Makefile
  echo 'define Package/lora_gateway/description'                                    >> Makefile
  echo -e '\tLow-level HAL for Semtech SX1301 LoRa concentrators.'                  >> Makefile
  echo 'endef'                                                                      >> Makefile
  echo ''                                                                           >> Makefile
  echo 'define Build/Compile'                                                       >> Makefile
  echo -e '\t$(MAKE) -C $(PKG_BUILD_DIR)'                                           >> Makefile
  echo 'endef'                                                                      >> Makefile
  echo ''                                                                           >> Makefile
  echo 'define Package/lora_gateway/install'                                        >> Makefile
  echo -e '\t$(INSTALL_DIR) $(1)/usr/lib/lora_gateway'                              >> Makefile
  echo -e '\t$(INSTALL_BIN) $(PKG_BUILD_DIR)/libloragw* $(1)/usr/lib/lora_gateway/' >> Makefile
  echo 'endef'                                                                      >> Makefile
  echo ''                                                                           >> Makefile
  echo '$(eval $(call BuildPackage,lora_gateway))'                                  >> Makefile
