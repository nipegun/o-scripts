# Script: mapa-de-red.sh

# Objetivo: listar todos los hosts activos por cada interfaz con IP privada asignada,
#            ordenando las IPs de forma ascendente.

# Requiere: arp-scan, iproute2, awk, grep, sort

echo "===== Mapa de red detectado ====="
echo

# Detectar interfaces con IP privada asignada
ip -4 -o addr show | awk '{print $2 ":" $4}' | while IFS=: read -r vInterfaz vIPCIDR; do
  vIP="${vIPCIDR%%/*}"

  # Filtrar IPs privadas (RFC1918)
  if [[ "$vIP" =~ ^10\. ]] || [[ "$vIP" =~ ^192\.168\. ]] || \
     [[ "$vIP" =~ ^172\.1[6-9]\. ]] || [[ "$vIP" =~ ^172\.2[0-9]\. ]] || [[ "$vIP" =~ ^172\.3[0-1]\. ]]; then

    echo "Interfaz: $vInterfaz ($vIPCIDR)"
    echo "---------------------------------------------"

    # Escanear red y ordenar IPs
    arp-scan -I "$vInterfaz" --localnet 2>/dev/null | \
      grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | \
      sort -t . -k1,1n -k2,2n -k3,3n -k4,4n | \
      awk '{printf " %-15s  %-17s  %s\n", $1, $2, $3}'

    echo
  fi
done

echo "===== Fin del mapa de red ====="
