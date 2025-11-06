#!/bin/sh

vFecha=$(date +"a%Ym%md%dh%Hm%Ms%S%3N" | sed 's/\([0-9]\{3\}\)$/ms\1/')

#curl -sLk https://raw.githubusercontent.com/nipegun/o-scripts/refs/heads/master/Sistema/ArpScan-CompletoConHostname.sh | sh -s -- -json | tee /tmp/ArpScanCompleto.json
curl -sLk https://raw.githubusercontent.com/nipegun/o-scripts/refs/heads/master/Sistema/ArpScan-CompletoConHostname.sh -o /tmp/ArpScan-CompletoConHostname.sh
sh /tmp/ArpScan-CompletoConHostname.sh -json | tee /tmp/ArpScanCompleto.json
echo ""
echo "Guardado en /tmp/ArpScanCompleto.json"
echo ""

curl -sLk https://raw.githubusercontent.com/nipegun/o-scripts/refs/heads/master/Sistema/Red-Mapa-Crear-EnJSON.sh -o /tmp/Red-Mapa-Crear-EnJSON.sh
sh /tmp/Red-Mapa-Crear-EnJSON.sh /tmp/ArpScanCompleto.json | tee /tmp/MapaDeRed.json
echo ""
echo "Guardado en /tmp/MapaDeRed.json"
echo ""


curl -sLk https://raw.githubusercontent.com/nipegun/o-scripts/refs/heads/master/Sistema/Red-Mapa-ConvertirJSONenHTML.sh -o /tmp/Red-Mapa-ConvertirJSONenHTML.sh
/tmp/Red-Mapa-ConvertirJSONenHTML.sh /tmp/MapaDeRed.json | tee /tmp/MapaDeRed.html
echo ""
echo "Guardado en /tmp/MapaDeRed.html"
echo ""

