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

# Abrir WireGuard en el cortafuegos
uci add firewall rule
uci set firewall.@rule[-1].src="*"
uci set firewall.@rule[-1].target="ACCEPT"
uci set firewall.@rule[-1].proto="udp"
uci set firewall.@rule[-1].dest_port="1234"
uci set firewall.@rule[-1].name="Allow-Wireguard-Inbound"
uci commit firewall
/etc/init.d/firewall restart

# Add the firewall zone
uci add firewall zone
uci set firewall.@zone[-1].name='wg'
uci set firewall.@zone[-1].input='ACCEPT'
uci set firewall.@zone[-1].forward='ACCEPT'
uci set firewall.@zone[-1].output='ACCEPT'
uci set firewall.@zone[-1].masq='1'

# Add the WG interface to it
uci set firewall.@zone[-1].network='wg0'

# Forward WAN and LAN traffic to/from it
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

# Generate the private key, setting it to only be readable by the current user and group.
umask 077 && wg genkey > privkey
# Derive the public key from it
cat privkey | wg pubkey > pubkey

# wg0 is the name of the wireguard interface, replace it if you wish.
uci set network.wg0="interface"
uci set network.wg0.proto="wireguard"
uci set network.wg0.private_key="$(cat privkey)"

# You may change this port to your liking, ports of popular services get through more firewalls.
# Just remember it for when you have to configure the firewall later.
uci set network.wg0.listen_port="1234"
uci add_list network.wg0.addresses='<A /64 (or greater) IPv6 subnet for client use>'
uci add_list network.wg0.addresses='<An IPv4 subnet for client use, in CIDR notation>'

# Save the changes
uci commit network
/etc/init.d/network reload
