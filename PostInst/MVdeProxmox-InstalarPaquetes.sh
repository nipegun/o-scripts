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
  apk add qemu-ga

# Controladores ethernet
  apk update
  # Adaptador Intel 82575/82576
    apk add kmod-igb
  # Adaptador Intel
    apk add kmod-e1000

# Controladores Wireless
  apk update
  apk add kmod-mac80211
  # Tarjetas Atheros
    apk add kmod-ath
    apk add kmod-ath9k
  # Compex a/b/g/n/ac Wave 2
    apk add kmod-ath10k-ct
    apk add ath10k-firmware-qca9984-ct-htt
  # MediaTek MT7615 (AC) 
    apk add kmod-mt7615-firmware
    apk add kmod-mt7615e
  # Mediatek MT7915E (AX)
    apk add kmod-mt7915-firmware
    apk add kmod-mt7915e
  # Mediatek MT7921K (AX)
    apk add kmod-mt7921-firmware
    apk add kmod-mt7921e

# USB 2
  apk update
  apk add kmod-usb2
  apk add kmod-usb-core
  apk add kmod-usb-ehci
  apk add kmod-usb-ohci
  apk add usbutils
  apk add usbids

# USB 3
  apk update
  apk add kmod-usb3
  apk add kmod-usb-xhci-hcd

# PCI
  apk update
  apk add pciutils
  apk add pciids

# Software

  # Herramientas para terminal (mandatorias para el funcionamiento del sistema)
    apk update
    apk add base-files
    apk add busybox
    apk add dnsmasq
    apk add dropbear
    apk add wpad-basic-mbedtls # Más liviano que hostapd-openssl 
    apk add libc
    apk add libgcc
    apk add libustream-mbedtls # Más liviano que libustream-openssl
    apk add logd
    apk add netifd
    apk add nftables
    apk add openssh-sftp-server
    apk add procd
    apk add procd-ujail
    apk add procd-seccomp
    apk add uci

  # Herramientas para terminal (extra)
    apk update
    apk add mc
    apk add nano
    apk add curl
    apk add git
    apk add hwclock
    apk add ethtool

  # Acceso a volúmenes
    apk update
    apk add e2fsprogs
    apk add f2fsck
    apk add fstools
    apk add blkid
    apk add dosfstools
    apk add fdisk
    apk add kmod-fs-vfat
    apk add kmod-usb-storage
    apk add parted
    apk add lsblk

    #apk add mkf2fs
    #apk add block-mount
    #apk add blockd
    #apk add blockdev
    ##apk add nand-utils

  # Paquetes de certificados
    apk update
    apk add ca-bundle
    apk add ca-certificates
    #apk add libustream-openssl
    apk add libustream-mbedtls

  # Web
    apk update
    apk add luci-ssl
    apk add luci-i18n-base-es

    # Adblock
      apk update
      apk add adblock
      apk add luci-app-adblock
      apk add luci-i18n-adblock-es
      apk add tcpdump
      apk add msmtp

    # DDNS
      apk update
      apk add ddns-scripts
      apk add ddns-scripts-services
      apk add luci-app-ddns
      apk add luci-i18n-ddns-es
      apk add bind-host

    # Cortafuegos
      apk update
      apk add firewall4
      apk add luci-app-firewall
      apk add luci-i18n-firewall-es

    # apk
      apk update
      apk add luci-app-package-manager
      apk add luci-i18n-package-manager-es

    # uPnP
      apk update
      apk add luci-app-upnp
      apk add luci-i18n-upnp-es

    # Programación Wifi
      apk update
      apk add wifischedule
      apk add luci-app-wifischedule
      apk add luci-i18n-wifischedule-es

    # Wake on LAN
      apk update
      apk add luci-app-wol # (Instala la dependencia etherwake)
      apk add luci-i18n-wol-es

    # Terminal en LUCI
      apk update
      apk add luci-app-ttyd
      apk add luci-i18n-ttyd-es

    # Watchcat
      apk update
      apk add luci-app-watchcat
      apk add luci-i18n-watchcat-es

    # Ejecutar scripts o comandos desde LUCI (Agrega Sistema >> Comandos personalizados)
      apk update
      apk add luci-app-commands
      apk add luci-i18n-commands-es

    # VPN
      apk update
      apk add kmod-wireguard
      apk add wireguard-tools
      apk add luci-proto-wireguard
      apk add qrencode

    # Módem
      apk update
      apk add luci-proto-modemmanager

      # MÓDEM EC25 (Modo QMI)
        apk update
        apk add kmod-usb-serial
        apk add kmod-usb-serial-wwan # Kernel support for USB GSM and CDMA modems
        apk add kmod-usb-serial-option

        apk add kmod-mii
        apk add kmod-usb-net
        apk add kmod-usb-wdm
        apk add kmod-usb-net-qmi-wwan # QMI WWAN driver for Qualcomm MSM based 3G and LTE modems
        apk add wwan
        apk add uqmi

        apk add usb-modeswitch
        apk add minicom

    # luci-compat
      #apk add luci-compat
