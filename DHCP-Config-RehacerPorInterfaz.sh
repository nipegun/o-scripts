#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para rehacer la configuración de OpenWrt al estilo nipegun
#
# Ejecución remota:
#   curl -s https://raw.githubusercontent.com/nipegun/o-scripts/master/DHCP-Config-RehacerPorInterfaz.sh | sh
# ----------

# Definir el nombre de las interfaces de red del sistema
  vNombresDeInterfacesDeRed="intlan intiot intinv"

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Notificar inicio de ejecución del script
  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de reconfiguración de DHCP y DNSMasq...${cFinColor}"
  echo ""

# Quitar las instancias DHCP configuradas
  echo ""
  echo "    Quitando las instancias DHCP y DNSMasq configuradas..."
  echo ""
  while uci -q delete dhcp.@dnsmasq[0]; do :; done
  while uci -q delete dhcp.@dhcp[0]; do :; done

# Crear una instancia de DHCP y DNSMasq por cada interfaz de red
  echo ""
  echo "    Creando una instancia DHCP y DNSMasq por cada nombre de interfaz indicada..."
  echo ""
  for vNombreInterfaz in ${vNombresDeInterfacesDeRed}
    do
      uci set dhcp.${vNombreInterfaz}_dns="dnsmasq"
      uci set dhcp.${vNombreInterfaz}_dns.domainneeded="1"
      uci set dhcp.${vNombreInterfaz}_dns.boguspriv="1"
      uci set dhcp.${vNombreInterfaz}_dns.filterwin2k="0"
      uci set dhcp.${vNombreInterfaz}_dns.localise_queries="1"
      uci set dhcp.${vNombreInterfaz}_dns.rebind_protection="1"
      uci set dhcp.${vNombreInterfaz}_dns.rebind_localhost="1"
      uci set dhcp.${vNombreInterfaz}_dns.local="/${vNombreInterfaz}/"
      uci set dhcp.${vNombreInterfaz}_dns.domain="${vNombreInterfaz}"
      uci set dhcp.${vNombreInterfaz}_dns.expandhosts="1"
      uci set dhcp.${vNombreInterfaz}_dns.nonegcache="0"
      uci set dhcp.${vNombreInterfaz}_dns.authoritative="1"
      uci set dhcp.${vNombreInterfaz}_dns.readethers="1"
      uci set dhcp.${vNombreInterfaz}_dns.leasefile="/tmp/dhcp.leases.${vNombreInterfaz}"
      uci set dhcp.${vNombreInterfaz}_dns.resolvfile="/tmp/resolv.conf.d/resolv.conf.auto"
      uci set dhcp.${vNombreInterfaz}_dns.nonwildcard="1"
      uci add_list dhcp.${vNombreInterfaz}_dns.interface="${vNombreInterfaz}"
      uci add_list dhcp.${vNombreInterfaz}_dns.notinterface="loopback"
      uci set dhcp.${vNombreInterfaz}="dhcp"
      uci set dhcp.${vNombreInterfaz}.instance="${vNombreInterfaz}_dns"
      uci set dhcp.${vNombreInterfaz}.interface="${vNombreInterfaz}"
      uci set dhcp.${vNombreInterfaz}.start="100"
      uci set dhcp.${vNombreInterfaz}.limit="99"
      uci set dhcp.${vNombreInterfaz}.leasetime="12h"
    done
  uci -q delete dhcp.@dnsmasq[0].notinterface

# Aplicar los cambios
  echo ""
  echo "    Aplicando los cambios..."
  echo ""
  uci commit dhcp

# Reiniciar el servicio
  echo ""
  echo "    Reiniciando el servicio dnsmasq..."
  echo ""
  service dnsmasq restart

