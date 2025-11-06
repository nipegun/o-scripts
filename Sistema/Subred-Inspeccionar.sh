#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para inspeccionar la subred indicada usando nmap
#
# Ejecución remota:
#   curl -sLk 
# ----------

CantArgsCorrectos=1
ArgsInsuficientes=65

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

if [ $# -ne $CantArgsCorrectos ]
  then
    echo ""
    echo "--------------------------------------------------------------------------"
    echo -e "${ColorRojo}Mal uso del script.${FinColor} El uso correcto sería:"
    echo ""
    echo -e "  $0 ${ColorVerde}[IP de la red]${FinColor}"
    echo ""
    echo "Ejemplo:"
    echo ""
    echo "  $0 192.168.0.0/24"
    echo "--------------------------------------------------------------------------"
    echo ""
    exit $ArgsInsuficientes
  else
    echo ""
    echo -e "${ColorVerde}Inspeccionando la subred...${FinColor}"
    echo ""

    opkg update > /dev/null
    opkg install nmap > /dev/null
    
    echo ""
    echo "Enviando ping a toda la subred..."
    echo ""
    
    nmap -sP $1 > /tmp/SubredPing.txt
    
    echo ""
    echo "Lista de clientes que respondieron a la petición de ping:"
    echo ""
    
    # Limpiar el archivo /tmp/SubredPing.txt quitando lo que no interesa
    sed -i -e 's|Nmap scan report for ||g' /tmp/SubredPing.txt
    sed -i -e 's|MAC Address: ||g' /tmp/SubredPing.txt
    cat /tmp/SubredPing.txt | grep -v "Starting" | grep -v "Host is up" | grep -v "Nmap done" > /tmp/SubredPing.txt
    # Agregar un espacio tabulado al final de cada línea
    sed -i 's/$/ ooo\tooo &/' /tmp/SubredPing.txt
    # Cortar las líneas pares y agregarlas al final de las impares.
    sed -i 'N;s/\n/ /' /tmp/SubredPing.txt
    sed -i -e 's|ooo||g' /tmp/SubredPing.txt
    cat /tmp/SubredPing.txt
    
    echo ""
    echo "Enviando TCP (SYN---SYN-ACK---ACK---RST-ACK)..."
    echo ""
    
    nmap -sT $1 > /tmp/SubredTCP.txt
    cat /tmp/SubredTCP.txt
    
    echo ""
    echo "Enviando TCP (SYN---SYN-ACK---RST)..."
    echo ""
    
    nmap -sS $1 > /tmp/SubredTCPAborted.txt
    cat /tmp/SubredTCPAborted.txt
fi
