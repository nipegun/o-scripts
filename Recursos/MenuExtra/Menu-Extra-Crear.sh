#!/bin/sh

# ----------
# Script de NiPeGun para crear un menú extra en LUCI
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/o-scripts/refs/heads/master/Recursos/MenuExtra/Menu-Extra-Crear.sh | sh
# ----------

echo 'nameserver 9.9.9.9' > /etc/resolv.conf

opkg update

opkg install luci-compat

# Asegurarse de que exista la carpeta para los controllers
  mkdir -p /usr/lib/lua/luci/controller/ 2> /dev/null

# Descargar el controlador de menú
  curl -sL https://raw.githubusercontent.com/nipegun/o-scripts/refs/heads/master/Recursos/MenuExtra/extra.lua -o /usr/lib/lua/luci/controller/

# Crear las vistas
  

# Reiniciar uhttpd
  /etc/init.d/uhttpd restart

