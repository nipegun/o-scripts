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
  opkg update
  opkg install qemu-ga

# Controladores ethernet
  opkg update
  # Adaptador Intel 82575/82576
    opkg install kmod-igb
  # Adaptador Intel
    opkg install kmod-e1000

# Controladores Wireless
  opkg update
  opkg install kmod-mac80211
  opkg install kmod-mt7915-firmware
  opkg install kmod-mt7915e
  opkg install kmod-mt7615e
  opkg install kmod-ath
  opkg install kmod-ath9k
  # Adaptadores Wifi Compex a/b/g/n/ac Wave 2
    opkg install kmod-ath10k-ct
    opkg install ath10k-firmware-qca9984-ct-htt

# USB 2
  opkg update
  opkg install kmod-usb2
  opkg install kmod-usb-core
  opkg install kmod-usb-ehci
  opkg install kmod-usb-ohci
  opkg install usbutils
  opkg install usbids

# USB 3
  opkg update
  opkg install kmod-usb3
  opkg install kmod-usb-xhci-hcd

# PCI
  opkg update
  opkg install pciutils
  opkg install pciids

# Software

  # Herramientas para terminal (mandatorias para el funcionamiento del sistema)
    opkg update
    opkg install base-files
    opkg install busybox
    opkg install dnsmasq
    opkg install dropbear
    opkg install wpad-basic-mbedtls # Más liviano que hostapd-openssl 
    opkg install libc
    opkg install libgcc
    opkg install libustream-mbedtls # Más liviano que libustream-openssl
    opkg install logd
    opkg install netifd
    opkg install nftables
    opkg install openssh-sftp-server
    opkg install opkg
    opkg install procd
    opkg install procd-ujail
    opkg install procd-seccomp
    opkg install uci

  # Herramientas para terminal (extra)
    opkg update
    opkg install mc
    opkg install nano
    opkg install curl
    opkg install git
    opkg install hwclock
    opkg install ethtool

  # Acceso a volúmenes
    opkg update
    opkg install e2fsprogs
    opkg install f2fsck
    opkg install fstools
    #opkg install mkf2fs
    opkg install blkid
    #opkg install block-mount
    #opkg install blockd
    #opkg install blockdev
    opkg install dosfstools
    opkg install fdisk
    opkg install kmod-fs-vfat
    opkg install kmod-usb-storage
    opkg install parted
    #opkg install nand-utils
    opkg install lsblk

  # Paquetes de certificados
    opkg update
    opkg install ca-bundle
    opkg install ca-certificates
    #opkg install libustream-openssl
    opkg install libustream-mbedtls

  # Web
    opkg update
    opkg install luci
    opkg install luci-i18n-base-es

    # Adblock
      opkg update
      opkg install adblock
      opkg install luci-app-adblock
      opkg install luci-i18n-adblock-es
      opkg install tcpdump
      opkg install msmtp

    # DDNS
      opkg update
      opkg install ddns-scripts
      opkg install ddns-scripts-services
      opkg install luci-app-ddns
      opkg install luci-i18n-ddns-es
      opkg install bind-host

    # Cortafuegos
      opkg update
      opkg install firewall4
      opkg install luci-app-firewall
      opkg install luci-i18n-firewall-es

    # OPKG
      opkg update
      opkg install opkg
      opkg install luci-app-package-manager
      opkg install luci-i18n-package-manager-es

    # uPnP
      opkg update
      opkg install luci-app-upnp
      opkg install luci-i18n-upnp-es

    # Programación Wifi
      opkg update
      opkg install wifischedule
      opkg install luci-app-wifischedule
      opkg install luci-i18n-wifischedule-es

    # Wake on LAN
      opkg update
      opkg install luci-app-wol # (Instala la dependencia etherwake)
      opkg install luci-i18n-wol-es

    # Terminal en LUCI
      opkg update
      opkg install luci-app-ttyd
      opkg install luci-i18n-ttyd-es

    # Watchcat
      opkg update
      opkg install luci-app-watchcat
      opkg install luci-i18n-watchcat-es

    # Ejecutar scripts o comandos desde LUCI (Agrega Sistema >> Comandos personalizados)
      opkg update
      opkg install luci-app-commands
      opkg install luci-i18n-commands-es

    # VPN
      opkg update
      opkg install kmod-wireguard
      opkg install wireguard-tools
      opkg install luci-proto-wireguard
      opkg install qrencode

    # Módem
      opkg update
      opkg install luci-proto-modemmanager

      # MÓDEM EC25 (Modo QMI)
        opkg update
        opkg install kmod-usb-serial
        opkg install kmod-usb-serial-wwan # Kernel support for USB GSM and CDMA modems
        opkg install kmod-usb-serial-option

        opkg install kmod-mii
        opkg install kmod-usb-net
        opkg install kmod-usb-wdm
        opkg install kmod-usb-net-qmi-wwan # QMI WWAN driver for Qualcomm MSM based 3G and LTE modems
        opkg install wwan
        opkg install uqmi

        opkg install usb-modeswitch
        opkg install minicom
