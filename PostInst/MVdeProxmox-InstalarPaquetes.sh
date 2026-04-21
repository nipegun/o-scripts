#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para configurar OpenWrt como MV de Proxmox
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/o-scripts/master/PostInst/MVdeProxmox-InstalarPaquetes.sh | sh
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
  apk update
  apk install qemu-ga

# Controladores ethernet
  apk update
  # Adaptador Intel 82575/82576
    apk install kmod-igb
  # Adaptador Intel
    apk install kmod-e1000

# Controladores Wireless
  apk update
  apk install kmod-mac80211
  # Tarjetas Atheros
    apk install kmod-ath
    apk install kmod-ath9k
  # Compex a/b/g/n/ac Wave 2
    apk install kmod-ath10k-ct
    apk install ath10k-firmware-qca9984-ct-htt
  # MediaTek MT7615 (AC) 
    apk install kmod-mt7615-firmware
    apk install kmod-mt7615e
  # Mediatek MT7915E (AX)
    apk install kmod-mt7915-firmware
    apk install kmod-mt7915e
  # Mediatek MT7921K (AX)
    apk install kmod-mt7921-firmware
    apk install kmod-mt7921e

# USB 2
  apk update
  apk install kmod-usb2
  apk install kmod-usb-core
  apk install kmod-usb-ehci
  apk install kmod-usb-ohci
  apk install usbutils
  apk install usbids

# USB 3
  apk update
  apk install kmod-usb3
  apk install kmod-usb-xhci-hcd

# PCI
  apk update
  apk install pciutils
  apk install pciids

# Software

  # Herramientas para terminal (mandatorias para el funcionamiento del sistema)
    apk update
    apk install base-files
    apk install busybox
    apk install dnsmasq
    apk install dropbear
    apk install wpad-basic-mbedtls # Más liviano que hostapd-openssl 
    apk install libc
    apk install libgcc
    apk install libustream-mbedtls # Más liviano que libustream-openssl
    apk install logd
    apk install netifd
    apk install nftables
    apk install openssh-sftp-server
    apk install apk
    apk install procd
    apk install procd-ujail
    apk install procd-seccomp
    apk install uci

  # Herramientas para terminal (extra)
    apk update
    apk install mc
    apk install nano
    apk install curl
    apk install git
    apk install hwclock
    apk install ethtool

  # Acceso a volúmenes
    apk update
    apk install e2fsprogs
    apk install f2fsck
    apk install fstools
    apk install blkid
    apk install dosfstools
    apk install fdisk
    apk install kmod-fs-vfat
    apk install kmod-usb-storage
    apk install parted
    apk install lsblk

    #apk install mkf2fs
    #apk install block-mount
    #apk install blockd
    #apk install blockdev
    ##apk install nand-utils

  # Paquetes de certificados
    apk update
    apk install ca-bundle
    apk install ca-certificates
    #apk install libustream-openssl
    apk install libustream-mbedtls

  # Web
    apk update
    apk install luci
    apk install luci-i18n-base-es

    # Adblock
      apk update
      apk install adblock
      apk install luci-app-adblock
      apk install luci-i18n-adblock-es
      apk install tcpdump
      apk install msmtp

    # DDNS
      apk update
      apk install ddns-scripts
      apk install ddns-scripts-services
      apk install luci-app-ddns
      apk install luci-i18n-ddns-es
      apk install bind-host

    # Cortafuegos
      apk update
      apk install firewall4
      apk install luci-app-firewall
      apk install luci-i18n-firewall-es

    # apk
      apk update
      apk install apk
      apk install luci-app-package-manager
      apk install luci-i18n-package-manager-es

    # uPnP
      apk update
      apk install luci-app-upnp
      apk install luci-i18n-upnp-es

    # Programación Wifi
      apk update
      apk install wifischedule
      apk install luci-app-wifischedule
      apk install luci-i18n-wifischedule-es

    # Wake on LAN
      apk update
      apk install luci-app-wol # (Instala la dependencia etherwake)
      apk install luci-i18n-wol-es

    # Terminal en LUCI
      apk update
      apk install luci-app-ttyd
      apk install luci-i18n-ttyd-es

    # Watchcat
      apk update
      apk install luci-app-watchcat
      apk install luci-i18n-watchcat-es

    # Ejecutar scripts o comandos desde LUCI (Agrega Sistema >> Comandos personalizados)
      apk update
      apk install luci-app-commands
      apk install luci-i18n-commands-es

    # VPN
      apk update
      apk install kmod-wireguard
      apk install wireguard-tools
      apk install luci-proto-wireguard
      apk install qrencode

    # Módem
      apk update
      apk install luci-proto-modemmanager

      # MÓDEM EC25 (Modo QMI)
        apk update
        apk install kmod-usb-serial
        apk install kmod-usb-serial-wwan # Kernel support for USB GSM and CDMA modems
        apk install kmod-usb-serial-option

        apk install kmod-mii
        apk install kmod-usb-net
        apk install kmod-usb-wdm
        apk install kmod-usb-net-qmi-wwan # QMI WWAN driver for Qualcomm MSM based 3G and LTE modems
        apk install wwan
        apk install uqmi

        apk install usb-modeswitch
        apk install minicom
