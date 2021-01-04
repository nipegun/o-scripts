#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#---------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar wireguard en OpenWrt
#---------------------------------------------------------------------

# Instalar paquetes
opkg update
opkg install wireguard
opkg install luci-app-wireguard
opkg install luci-proto-wireguard
opkg install kmod-wireguard
opkg install wireguard-tools
opkg install ipset
opkg install qrencode

# Agregar regla del cortafuegos para aceptar conexiones
uci add firewall rule
uci set firewall.@rule[-1].src="*"
uci set firewall.@rule[-1].target="ACCEPT"
uci set firewall.@rule[-1].proto="udp"
uci set firewall.@rule[-1].dest_port="1234"
uci set firewall.@rule[-1].name="Allow-Wireguard-Inbound"
uci commit firewall
/etc/init.d/firewall restart

# Agregar la zona del cortafuegos
uci add firewall zone
uci set firewall.@zone[-1].name='wg'
uci set firewall.@zone[-1].input='ACCEPT'
uci set firewall.@zone[-1].forward='ACCEPT'
uci set firewall.@zone[-1].output='ACCEPT'
uci set firewall.@zone[-1].masq='1'

# Agregar la interfaz wg a la zona del cortafuegos
uci set firewall.@zone[-1].network='wg0'

# Reenviar tráfico desde la zona wan y la zona lan hacia la interfaz wg y viceversa
uci add firewall forwarding
uci set firewall.@forwarding[-1].src='wg'
uci set firewall.@forwarding[-1].dest='wan'
uci add firewall forwarding
uci set firewall.@forwarding[-1].src='wg'
uci set firewall.@forwarding[-1].dest='lan'
uci add firewall forwarding
uci set firewall.@forwarding[-1].src='lan'
uci set firewall.@forwarding[-1].dest='wg'
uci add firewall forwarding
uci set firewall.@forwarding[-1].src='wan'
uci set firewall.@forwarding[-1].dest='wg'
uci commit firewall
/etc/init.d/firewall restart

# Generar la clave privada
mkdir -p /root/WireGuard/
wg genkey > /root/WireGuard/WireGuardServerPrivate.key

# Generar la clave pública a partir de la clave privada generada antes
cat /root/WireGuard/WireGuardServerPrivate.key | wg pubkey > /root/WireGuard/WireGuardServerPublic.key

# Configurar la interfaz wg0
uci set network.wg0="interface"
uci set network.wg0.proto="wireguard"
uci set network.wg0.private_key="$(cat /root/WireGuard/WireGuardServerPrivate.key)"
uci set network.wg0.listen_port="51820"
uci add_list network.wg0.addresses='10.10.10.0/24'

# Guardar los cambios
uci commit network
/etc/init.d/network reload

