#!/bin/sh

# ----------
# Script de NiPeGun para crear un menú extra en LUCI
#
# Ejecución remota:
#   curl -sL 
# ----------

echo 'nameserver 9.9.9.9' > /etc/resolv.conf

opkg update

opkg install luci-compat

https://raw.githubusercontent.com/nipegun/o-scripts/refs/heads/master/Recursos/MenuExtra/extra.lua
