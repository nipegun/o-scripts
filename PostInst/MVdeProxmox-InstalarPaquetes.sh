#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para configurar OpenWrt como MV de Proxmox
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/o-scripts/master/PostInst/MVdeProxmox-Configurar.sh | sh
# ----------

vColorAzul="\033[0;34m"
vColorAzulClaro="\033[1;34m"
vColorVerde='\033[1;32m'
vColorRojo='\033[1;31m'
vFinColor='\033[0m'

echo ""
echo -e "${vColorAzulClaro}  Iniciando el script de instalación de paquetes para OpenWrt x86...${vFinColor}"
echo ""

# Paquetes de virtualización
  opkg update
  opkg install qemu-ga

# Paquetes de terminal
  opkg update
  opkg install nano
  opkg install mc
  opkg install pciutils

# Paquetes de red
  opkg update
  opkg install nmap
  opkg install wget
  opkg install git-http
  opkg install tcpdump
  opkg install msmtp

# Paquetes de certificados
  opkg update
  opkg install ca-bundle
  opkg install ca-certificates
  opkg install libustream-openssl

# Controladores WiFi
  opkg update
  opkg install hostapd-openssl
  opkg install kmod-mac80211
  opkg install kmod-ath
  opkg install kmod-ath9k
  # Adaptadores Wifi Compex a/b/g/n/ac Wave 2
    opkg install kmod-ath10k-ct
    opkg install ath10k-firmware-qca9984-ct-htt

# Controladores ethernet
  opkg update
  # Adaptador Intel 82575/82576
    opkg install kmod-igb
  # Adaptador Intel
    #opkg install kmod-e1000

# LUCI
  opkg update
  opkg install luci-i18n-base-es
  opkg install luci-i18n-firewall-es
  opkg install luci-i18n-adblock-es
  opkg install luci-i18n-qos-es
  opkg install luci-i18n-wifischedule-es
  opkg install luci-i18n-wireguard-es
  opkg install luci-i18n-wol-es

