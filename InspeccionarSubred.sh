#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------
#  Script de NiPeGun para inspeccionar la subred indicada usando nmap
#----------------------------------------------------------------------

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
    nmap -sP $1 > /var/tmp/Subred.txt
    
    echo ""
    echo "---------------------------------------------------------"
    echo "Lista de clientes que respondieron a la petición de ping:"
    echo "---------------------------------------------------------"
    echo ""
    
    # Limpiar el archivo /var/tmp/Subred.txt quitando lo que no interesa
    sed -i -e 's|Nmap scan report for ||g' /var/tmp/Subred.txt
    sed -i -e 's|MAC Address: ||g' /var/tmp/Subred.txt
    cat /var/tmp/Subred.txt | grep -v "Starting" | grep -v "Host is up" | grep -v "Nmap done" > /var/tmp/Subred.txt
    # Agregar un espacio tabulado al final de cada línea
    sed -i 's/$/ ---\t--- &/' /var/tmp/Subred.txt
    # Cortar las líneas pares y agregarlas al final de las impares.
    sed 'N;s/\n/ /' /var/tmp/Subred.txt > /var/tmp/Subred.txt
    sed -i -e 's|---||g' /var/tmp/Subred.txt
    cat /var/tmp/Subred.txt

    #rm -rf /var/tmp/Subred.txt

fi
