#!/bin/sh

# Script de NiPeGun para instalar y configurar LXC en OpenWrt

# Actualizar la lista de paquetes disponibles en los repositorios
  apk update

# Instalar lxc para LUCI para que se instalen todas las dependencias con él
  apk install luci-i18n-lxc-es

# Instalar compatibilidad con virtual ethernet para crear una red única para los contenedores
  apk install kmod-veth
