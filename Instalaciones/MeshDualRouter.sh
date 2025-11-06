#!/bin/sh
# ConfigurarMeshCableada.sh
# Script para configurar dos routers OpenWrt (Banana Pi BPI-R3)
# con roaming rápido (802.11r) y band steering (802.11k/v)
# conectados por cable Ethernet LAN↔LAN.

vRouter="$1"  # "principal" o "secundario"
vSSID="Casa"
vClave="claveSuperSegura"
vMovDom="4f57"

if [ -z "$vRouter" ]; then
  echo "Uso: $0 principal|secundario"
  exit 1
fi

echo "Configurando router $vRouter ..."

# --- Limpiar configuraciones anteriores ---
uci revert network
uci revert wireless
uci revert dhcp

# --- Configuración de red ---
uci batch <<EOF
set network.loopback=interface
set network.loopback.device='lo'
set network.loopback.proto='static'
set network.loopback.ipaddr='127.0.0.1'
set network.loopback.netmask='255.0.0.0'

set network.globals=globals
set network.globals.ula_prefix='fd00:abcd::/48'

set network.device=device
set network.device.name='br-lan'
set network.device.type='bridge'
add_list network.device.ports='lan1'
add_list network.device.ports='lan2'
add_list network.device.ports='lan3'
add_list network.device.ports='lan4'

set network.lan=interface
set network.lan.device='br-lan'
set network.lan.proto='static'
set network.lan.netmask='255.255.255.0'
EOF

if [ "$vRouter" = "principal" ]; then
  uci batch <<EOF
set network.lan.ipaddr='192.168.1.1'
set network.lan.ip6assign='60'
set network.wan=interface
set network.wan.device='wan'
set network.wan.proto='dhcp'
set network.wan6=interface
set network.wan6.device='wan'
set network.wan6.proto='dhcpv6'
EOF
else
  uci batch <<EOF
set network.lan.ipaddr='192.168.1.2'
set network.lan.gateway='192.168.1.1'
add_list network.lan.dns='192.168.1.1'
EOF
fi

uci commit network

# --- DHCP ---
uci batch <<EOF
set dhcp.dnsmasq=main
set dhcp.dnsmasq.domainneeded='1'
set dhcp.dnsmasq.boguspriv='1'
set dhcp.dnsmasq.localise_queries='1'
set dhcp.dnsmasq.rebind_protection='1'
set dhcp.dnsmasq.local='/lan/'
set dhcp.dnsmasq.domain='lan'
set dhcp.dnsmasq.expandhosts='1'
set dhcp.dnsmasq.authoritative='1'
set dhcp.dnsmasq.readethers='1'
set dhcp.dnsmasq.leasefile='/tmp/dhcp.leases'
set dhcp.dnsmasq.resolvfile='/tmp/resolv.conf.d/resolv.conf.auto'

set dhcp.lan=dhcp
set dhcp.lan.interface='lan'
EOF

if [ "$vRouter" = "principal" ]; then
  uci batch <<EOF
set dhcp.lan.start='100'
set dhcp.lan.limit='150'
set dhcp.lan.leasetime='12h'
EOF
else
  uci set dhcp.lan.ignore='1'
fi

uci commit dhcp

# --- WiFi (radio0 = 2.4GHz, radio1 = 5GHz) ---
uci batch <<EOF
set wireless.radio0=wifi-device
set wireless.radio0.type='mac80211'
set wireless.radio0.path='platform/18000000.wmac'
set wireless.radio0.hwmode='11g'
set wireless.radio0.channel='6'
set wireless.radio0.htmode='HT40'
set wireless.radio0.country='ES'

set wireless.radio1=wifi-device
set wireless.radio1.type='mac80211'
set wireless.radio1.path='platform/18000000.wmac+1'
set wireless.radio1.hwmode='11a'
set wireless.radio1.channel='36'
set wireless.radio1.htmode='VHT80'
set wireless.radio1.country='ES'

# 2.4 GHz
set wireless.wifi24=wifi-iface
set wireless.wifi24.device='radio0'
set wireless.wifi24.network='lan'
set wireless.wifi24.mode='ap'
set wireless.wifi24.ssid='$vSSID'
set wireless.wifi24.encryption='psk2'
set wireless.wifi24.key='$vClave'
set wireless.wifi24.ieee80211r='1'
set wireless.wifi24.mobility_domain='$vMovDom'
set wireless.wifi24.ft_over_ds='1'
set wireless.wifi24.ft_psk_generate_local='1'
set wireless.wifi24.ieee80211k='1'
set wireless.wifi24.rrm_neighbor_report='1'
set wireless.wifi24.rrm_beacon_report='1'
set wireless.wifi24.ieee80211v='1'
set wireless.wifi24.bss_transition='1'
set wireless.wifi24.time_advertisement='2'
set wireless.wifi24.time_zone='CET-1CEST,M3.5.0/2,M10.5.0/3'

# 5 GHz
set wireless.wifi5=wifi-iface
set wireless.wifi5.device='radio1'
set wireless.wifi5.network='lan'
set wireless.wifi5.mode='ap'
set wireless.wifi5.ssid='$vSSID'
set wireless.wifi5.encryption='psk2'
set wireless.wifi5.key='$vClave'
set wireless.wifi5.ieee80211r='1'
set wireless.wifi5.mobility_domain='$vMovDom'
set wireless.wifi5.ft_over_ds='1'
set wireless.wifi5.ft_psk_generate_local='1'
set wireless.wifi5.ieee80211k='1'
set wireless.wifi5.rrm_neighbor_report='1'
set wireless.wifi5.rrm_beacon_report='1'
set wireless.wifi5.ieee80211v='1'
set wireless.wifi5.bss_transition='1'
set wireless.wifi5.time_advertisement='2'
set wireless.wifi5.time_zone='CET-1CEST,M3.5.0/2,M10.5.0/3'
EOF

uci commit wireless

# --- Reiniciar servicios ---
/etc/init.d/network restart
wifi reload

echo "Configuración aplicada correctamente."
if [ "$vRouter" = "principal" ]; then
  echo "→ Este router es el principal (DHCP activo, IP 192.168.1.1)"
else
  echo "→ Este router es el secundario (DHCP desactivado, IP 192.168.1.2)"
fi
