#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para descargar los archivos correspondientes a nano en el OpenWrt del SFP Lantiq con OpenWrt 14.07
#
# Ejecución remota:
#   curl -s https://raw.githubusercontent.com/nipegun/o-scripts/master/SFPLantiq/Paquete-Buscar-PorNombre.sh | sh
# ----------

vOpenWrt="14.07"

# ---------- No modificar a partir de aquí ----------

# Definir las variables de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  cFinColor='\033[0m'

# Definir cantidad de argumentos esperados a pasar al script
  cCantArgumEsperados=1

# Comprobar que se le haya pasado al menos un nombre de paquete al script
  if [ $# -ne $cCantArgumEsperados ]
    then

      echo ""
      echo -e "${cColorRojo}  Mal uso del script. El uso correcto sería: ${cFinColor}"
      echo "    $0 [NombreDelPaquete]"
      echo ""
      echo "  Ejemplo:"
      echo "    $0 'nano'"
      echo ""
      exit

    else

      # Crear la constante con el nombre del paquete
        vPaquete=$1

      # Guardar todos los paquetes de los repositorios en una lsita
        # base
          curl -sL https://archive.openwrt.org/barrier_breaker/$vOpenWrt/lantiq/xway/packages/base/        | sed 's->->\n-g' | grep href | cut -d '"' -f2 | cut -d'_' -f1  > /tmp/Paquetes-Todos-EnRepo.txt
        # luci
          curl -sL https://archive.openwrt.org/barrier_breaker/$vOpenWrt/lantiq/xway/packages/luci/        | sed 's->->\n-g' | grep href | cut -d '"' -f2 | cut -d'_' -f1 >> /tmp/Paquetes-Todos-EnRepo.txt
        # management
          curl -sL https://archive.openwrt.org/barrier_breaker/$vOpenWrt/lantiq/xway/packages/management/  | sed 's->->\n-g' | grep href | cut -d '"' -f2 | cut -d'_' -f1 >> /tmp/Paquetes-Todos-EnRepo.txt
        # oldpackages
          curl -sL https://archive.openwrt.org/barrier_breaker/$vOpenWrt/lantiq/xway/packages/oldpackages/ | sed 's->->\n-g' | grep href | cut -d '"' -f2 | cut -d'_' -f1 >> /tmp/Paquetes-Todos-EnRepo.txt
        # packages
          curl -sL https://archive.openwrt.org/barrier_breaker/$vOpenWrt/lantiq/xway/packages/packages/    | sed 's->->\n-g' | grep href | cut -d '"' -f2 | cut -d'_' -f1 >> /tmp/Paquetes-Todos-EnRepo.txt
        # routing
          curl -sL https://archive.openwrt.org/barrier_breaker/$vOpenWrt/lantiq/xway/packages/routing/     | sed 's->->\n-g' | grep href | cut -d '"' -f2 | cut -d'_' -f1 >> /tmp/Paquetes-Todos-EnRepo.txt
        # telephony
          curl -sL https://archive.openwrt.org/barrier_breaker/$vOpenWrt/lantiq/xway/packages/telephony/   | sed 's->->\n-g' | grep href | cut -d '"' -f2 | cut -d'_' -f1 >> /tmp/Paquetes-Todos-EnRepo.txt

      # Buscar el paquete indicado
        #cat /tmp/Paquetes-Todos-EnRepo.txt | grep $vPaquete | sort > /tmp/Paquetes-Selecc.txt
        echo ""
        echo "  Paquetes encontrados con ese nombre..."
        echo ""
        cat /tmp/Paquetes-Todos-EnRepo.txt | grep $vPaquete | sort

      # Obtener enlaces de descarga
        i="$vPaquete"
        # base
          vBase=$(curl -sL https://archive.openwrt.org/barrier_breaker/$vOpenWrt/lantiq/xway/packages/base/               | sed 's->->\n-g' | grep href | cut -d '"' -f2 | grep $i)
        # luci
          vLuci=$(curl -sL https://archive.openwrt.org/barrier_breaker/$vOpenWrt/lantiq/xway/packages/luci/               | sed 's->->\n-g' | grep href | cut -d '"' -f2 | grep $i)
        # management
          vManagement=$(curl -sL https://archive.openwrt.org/barrier_breaker/$vOpenWrt/lantiq/xway/packages/management/   | sed 's->->\n-g' | grep href | cut -d '"' -f2 | grep $i)
        # oldpackages
          vOldPackages=$(curl -sL https://archive.openwrt.org/barrier_breaker/$vOpenWrt/lantiq/xway/packages/oldpackages/ | sed 's->->\n-g' | grep href | cut -d '"' -f2 | grep $i)
        # packages
          vPackages=$(curl -sL https://archive.openwrt.org/barrier_breaker/$vOpenWrt/lantiq/xway/packages/packages/       | sed 's->->\n-g' | grep href | cut -d '"' -f2 | grep $i)
        # routing
          vRouting=$(curl -sL https://archive.openwrt.org/barrier_breaker/$vOpenWrt/lantiq/xway/packages/routing/         | sed 's->->\n-g' | grep href | cut -d '"' -f2 | grep $i)
        # telephony
          vTelephony=$(curl -sL https://archive.openwrt.org/barrier_breaker/$vOpenWrt/lantiq/xway/packages/telephony/     | sed 's->->\n-g' | grep href | cut -d '"' -f2 | grep $i)

      # Mostrar enlaces de descarga
        echo ""
        echo "  Buscando enlaces de descarga..."
        echo ""
        rm -rf /tmp/$vPaquete/ >/dev/null
        mkdir /tmp/$vPaquete/
        touch /tmp/$vPaquete/EnlacesDeDescargaDePaquetes.txt

        echo $vBase        | sed 's- -\n-g' | while IFS= read -r vLinea; do
          echo "https://archive.openwrt.org/barrier_breaker/$vOpenWrt/lantiq/xway/packages/base/$vLinea"        | grep -v '/$' >> /tmp/$vPaquete/EnlacesDeDescargaDePaquetes.txt
        done

        echo $vLuci        | sed 's- -\n-g' | while IFS= read -r vLinea; do
          echo "https://archive.openwrt.org/barrier_breaker/$vOpenWrt/lantiq/xway/packages/luci/$vLinea"        | grep -v '/$' >> /tmp/$vPaquete/EnlacesDeDescargaDePaquetes.txt
        done

        echo $vManagement  | sed 's- -\n-g' | while IFS= read -r vLinea; do
          echo "https://archive.openwrt.org/barrier_breaker/$vOpenWrt/lantiq/xway/packages/management/$vLinea"  | grep -v '/$' >> /tmp/$vPaquete/EnlacesDeDescargaDePaquetes.txt
        done

        echo $vOldPackages | sed 's- -\n-g' | while IFS= read -r vLinea; do
          echo "https://archive.openwrt.org/barrier_breaker/$vOpenWrt/lantiq/xway/packages/oldpackages/$vLinea" | grep -v '/$' >> /tmp/$vPaquete/EnlacesDeDescargaDePaquetes.txt
        done

        echo $vPackages    | sed 's- -\n-g' | while IFS= read -r vLinea; do
          echo "https://archive.openwrt.org/barrier_breaker/$vOpenWrt/lantiq/xway/packages/packages/$vLinea"    | grep -v '/$' >> /tmp/$vPaquete/EnlacesDeDescargaDePaquetes.txt
        done

        echo $vRouting     | sed 's- -\n-g' | while IFS= read -r vLinea; do
          echo "https://archive.openwrt.org/barrier_breaker/$vOpenWrt/lantiq/xway/packages/routing/$vLinea"     | grep -v '/$' >> /tmp/$vPaquete/EnlacesDeDescargaDePaquetes.txt
        done

        echo $vTelephony   | sed 's- -\n-g' | while IFS= read -r vLinea; do
          echo "https://archive.openwrt.org/barrier_breaker/$vOpenWrt/lantiq/xway/packages/telephony/$vLinea"   | grep -v '/$' >> /tmp/$vPaquete/EnlacesDeDescargaDePaquetes.txt
        done

      # Notificar enlaces encontrados
        echo ""
        echo "    Se han encontrado los siguientes enlaces..."
        echo ""
        cat /tmp/$vPaquete/EnlacesDeDescargaDePaquetes.txt
        echo ""

      # Descargar paquetes
        echo ""
        echo "  Descargando paquetes..."
        echo ""
        rm -f /tmp/$vPaquete/DescargarPaquetes.sh
        echo '#!/bin/bash' > /tmp/$vPaquete/DescargarPaquetes.sh
        cat /tmp/$vPaquete/EnlacesDeDescargaDePaquetes.txt | sed "s|^|curl -L |" | sed "s|$| -O |" >> /tmp/$vPaquete/DescargarPaquetes.sh
        chmod +x /tmp/$vPaquete/DescargarPaquetes.sh
        mkdir /tmp/$vPaquete/PaquetesDescargados/
        echo ""
        cd /tmp/$vPaquete/PaquetesDescargados/
        /tmp/$vPaquete/DescargarPaquetes.sh
        ls /tmp/$vPaquete/PaquetesDescargados/ | cut -d'_' -f1

      # Descomprimir paquetes
        echo ""
        echo "  Descomprimiendo paquetes..."
        echo ""
        mkdir /tmp/$vPaquete/PaquetesDescomprimidos/
        cp /tmp/$vPaquete/PaquetesDescargados/* /tmp/$vPaquete/PaquetesDescomprimidos/
        find /tmp/$vPaquete/PaquetesDescomprimidos/ -type f -exec bash -c 'for vArchivo; do mv "$vArchivo" "$(dirname "$vArchivo")/$(basename "$vArchivo" | cut -d"_" -f1).ipk"; done' bash {} +
        # Por cada archivo que encuentre en una carpeta, crear dentro de esa carpeta una carpeta por cada nombre de archivo
          #find /tmp/$vPaquete/PaquetesDescomprimidos/ -type f -exec bash -c 'for file; do dir="${file%.*}"; mkdir -p "$dir"; done' bash {} +
          find /tmp/$vPaquete/PaquetesDescomprimidos/ -type f -name "*.ipk" -exec bash -c 'for file; do dir="${file%.ipk}"; mkdir -p "$dir"; cd "$dir"; tar -xvzf "$file" -C "$dir"; done' bash {} +
        # Descomprimir data
          find /tmp/$vPaquete/PaquetesDescomprimidos/ -type f -name "data.tar.gz" -exec bash -c 'for file; do dir=$(dirname "$file")/data; mkdir -p "$dir"; tar -xzf "$file" -C "$dir"; done' bash {} +
        # Descomprimir control
          find /tmp/$vPaquete/PaquetesDescomprimidos/ -type f -name "control.tar.gz" -exec bash -c 'for file; do dir=$(dirname "$file")/control; mkdir -p "$dir"; tar -xzf "$file" -C "$dir"; done' bash {} +

      # Borrar archivos sobrantes
        find /tmp/$vPaquete/PaquetesDescomprimidos/ -type f -name "*.ipk"           -delete
        find /tmp/$vPaquete/PaquetesDescomprimidos/ -type f -name "*debian-binary"  -delete
        find /tmp/$vPaquete/PaquetesDescomprimidos/ -type f -name "*data.tar.gz"    -delete
        find /tmp/$vPaquete/PaquetesDescomprimidos/ -type f -name "*control.tar.gz" -delete

fi

