#!/bin/sh

# ----------
# Script de NiPeGun para x
#
# Requisitos previos:
#   echo 'nameserver 9.9.9.9' > /etc/resolv.conf && opkg update && opkg install coreutils-date jq
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/o-scripts/refs/heads/master/Sistema/Dispositivos-Conectados-PorInterfaz-Informe-EnHTML.sh | sh
#
# ----------

vFecha=$(date +"a%Ym%md%dh%Hm%Ms%S%3N" | sed 's/\([0-9]\{3\}\)$/ms\1/')

# Establecer servidores DNS
  echo 'nameserver 9.9.9.9'          > /etc/resolv.conf
  echo 'nameserver 149.112.112.112' >> /etc/resolv.conf

echo ""
echo "Obteniendo arp-scan completo de todas las interfaces con IP asignada..."
echo ""
if [ -f "/root/scripts/o-scripts/Sistema/ArpScan-CompletoConHostname.sh" ]; then
  sh /root/scripts/o-scripts/Sistema/ArpScan-CompletoConHostname.sh -json | tee /tmp/ArpScanCompleto.json
else
  curl -sL https://raw.githubusercontent.com/nipegun/o-scripts/refs/heads/master/Sistema/ArpScan-CompletoConHostname.sh -o /tmp/ArpScan-CompletoConHostname.sh
  sh /tmp/ArpScan-CompletoConHostname.sh -json | tee /tmp/ArpScanCompleto.json
fi
echo ""
echo "  Guardado en /tmp/ArpScanCompleto.json"
echo ""

echo ""
echo "Convirtiendo el escaneo arp a mapa de red en JSON..."
echo ""
if [ -f "/root/scripts/o-scripts/Sistema/Red-Mapa-Crear-EnJSON-DesdeArchivo.sh" ]; then
  sh /root/scripts/o-scripts/Sistema/Red-Mapa-Crear-EnJSON-DesdeArchivo.sh /tmp/ArpScanCompleto.json | tee /tmp/MapaDeRed.json
else
  curl -sL https://raw.githubusercontent.com/nipegun/o-scripts/refs/heads/master/Sistema/Red-Mapa-Crear-EnJSON-DesdeArchivo.sh -o /tmp/Red-Mapa-Crear-EnJSON-DesdeArchivo.sh
  sh /tmp/Red-Mapa-Crear-EnJSON-DesdeArchivo.sh /tmp/ArpScanCompleto.json | tee /tmp/MapaDeRed.json
fi
echo ""
echo "  Guardado en /tmp/MapaDeRed.json"
echo ""

echo ""
echo "Convirtiendo el mapa de red en JSON hacia HTML..."
echo "" 
if [ -f "/root/scripts/o-scripts/Sistema/Red-Mapa-ConvertirJSONenHTML-DesdeArchivo.sh" ]; then
  sh /root/scripts/o-scripts/Sistema/Red-Mapa-ConvertirJSONenHTML-DesdeArchivo.sh /tmp/MapaDeRed.json | tee /tmp/InformeDeDispositivosConectadosPorInterfaz.html
else
  curl -sL https://raw.githubusercontent.com/nipegun/o-scripts/refs/heads/master/Sistema/Red-Mapa-ConvertirJSONenHTML-DesdeArchivo.sh -o /tmp/Red-Mapa-ConvertirJSONenHTML-DesdeArchivo.sh
  sh /tmp/Red-Mapa-ConvertirJSONenHTML-DesdeArchivo.sh /tmp/MapaDeRed.json | tee /tmp/InformeDeDispositivosConectadosPorInterfaz.html
fi
echo ""
echo "  Guardado en /tmp/InformeDeDispositivosConectadosPorInterfaz.html"
echo ""

