#!/bin/sh

vFecha=$(date +"a%Ym%md%dh%Hm%Ms%S%3N" | sed 's/\([0-9]\{3\}\)$/ms\1/')

# Establecer servidores DNS
  echo 'nameserver 9.9.9.9'          > /etc/resolv.conf
  echo 'nameserver 149.112.112.112' >> /etc/resolv.conf

echo ""
echo "Obteniendo arps-can completo de todas las interfaces con IP..."
echo ""
#curl -sLk https://raw.githubusercontent.com/nipegun/o-scripts/refs/heads/master/Sistema/ArpScan-CompletoConHostname.sh | sh -s -- -json | tee /tmp/ArpScanCompleto.json
curl -sLk https://raw.githubusercontent.com/nipegun/o-scripts/refs/heads/master/Sistema/ArpScan-CompletoConHostname.sh -o /tmp/ArpScan-CompletoConHostname.sh
sh /tmp/ArpScan-CompletoConHostname.sh -json | tee /tmp/ArpScanCompleto.json
echo ""
echo "  Guardado en /tmp/ArpScanCompleto.json"
echo ""

echo ""
echo "Convirtiendo el escaneo arp a mapa de red en JSON..."
echo ""
curl -sLk https://raw.githubusercontent.com/nipegun/o-scripts/refs/heads/master/Sistema/Red-Mapa-Crear-EnJSON.sh -o /tmp/Red-Mapa-Crear-EnJSON.sh
sh /tmp/Red-Mapa-Crear-EnJSON.sh /tmp/ArpScanCompleto.json | tee /tmp/MapaDeRed.json
echo ""
echo "  Guardado en /tmp/MapaDeRed.json"
echo ""

echo ""
echo "Convirtiendo el mapa de red en JSON hacia HTML..."
echo "" 
curl -sLk https://raw.githubusercontent.com/nipegun/o-scripts/refs/heads/master/Sistema/Red-Mapa-ConvertirJSONenHTML.sh -o /tmp/Red-Mapa-ConvertirJSONenHTML.sh
sh /tmp/Red-Mapa-ConvertirJSONenHTML.sh /tmp/MapaDeRed.json | tee /tmp/MapaDeRed.html
echo ""
echo "  Guardado en /tmp/MapaDeRed.html"
echo ""

