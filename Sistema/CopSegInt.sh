#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para hacer copia de seguridad interna de OpenWrt
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/o-scripts/refs/heads/master/Sistema/CopSegInt.sh | sh
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/o-scripts/refs/heads/master/Sistema/CopSegInt.sh | nano -
# ----------

# Definir ubicaciones
  cCarpetaRaizDeCopias='/CopSegInt'
  cArchivoConDatosACopiar='/root/DataToBackup.txt'
  cArchivoDeLog='/var/log/CopiasDeSeguridad.log'

# Definir el momento de ejecución del script
  cFechaDeEjec=$(date +a%Ym%md%dh%Hm%Ms%S)

# Definir carpeta de destino
  cCarpetaDestino="$cCarpetaRaizDeCopias/$cFechaDeEjec"

# Notificar inicio de ejecución del script
  echo ""
  echo "  Iniciando el script de copia de seguridad interna el $cFechaDeEjec..."
  echo ""
  echo "    Carpeta destino de la copia: $cCarpetaDestino"
  echo ""

# Comprobar si existe el archivo con datos a copiar
  if ! test -f "$cArchivoConDatosACopiar"; then
    echo "    El archivo $cArchivoConDatosACopiar no existe."
    echo ""
    exit 1
  fi

# Crear la carpeta raíz de copia de seguridad
  if ! mkdir -p "$cCarpetaDestino"; then
    echo "  No se pudo crear la carpeta de destino: $cCarpetaDestino"
    echo ""
    exit 1
  fi

# Leer el archivo línea por línea
while IFS= read -r vLinea || [ -n "$vLinea" ]; do

  # Eliminar retorno de carro si el archivo viene de Windows
    vLinea=$(echo "$vLinea" | tr -d '\r')

  # Ignorar líneas vacías
    if [ -z "$vLinea" ]; then
      continue
    fi

  # Ignorar líneas que empiezan por #
    case "$vLinea" in
      \#*)
        continue
      ;;
    esac

  # Comprobar que sea una ruta absoluta
    case "$vLinea" in
      /*)
      ;;
      *)
        echo "      Ruta ignorada porque no es absoluta: $vLinea"
        continue
      ;;
    esac

  # Si termina en /, debe ser una carpeta existente
    case "$vLinea" in
      */)
        if ! test -d "$vLinea"; then
          echo "      Carpeta inexistente, ignorada: $vLinea"
          continue
        fi

        vRutaSinBarraFinal="${vLinea%/}"
        vRutaDestino="$cCarpetaDestino$vRutaSinBarraFinal"

        echo "    Copiando carpeta: $vLinea"

        if ! mkdir -p "$vRutaDestino"; then
          echo "      Error creando carpeta destino: $vRutaDestino"
          continue
        fi

        if ! cp -a "$vRutaSinBarraFinal/." "$vRutaDestino/"; then
          echo "      Error copiando: $vLinea"
          continue
        fi
      ;;

      *)
        if ! test -f "$vLinea"; then
          echo "      Archivo inexistente, ignorado: $vLinea"
          continue
        fi

        vRutaDestino="$cCarpetaDestino$vLinea"
        vCarpetaPadreDestino=$(dirname "$vRutaDestino")

        echo "    Copiando archivo: $vLinea"

        if ! mkdir -p "$vCarpetaPadreDestino"; then
          echo "      Error creando carpeta destino: $vCarpetaPadreDestino"
          continue
        fi

        if ! cp -a "$vLinea" "$vRutaDestino"; then
          echo "      Error copiando: $vLinea"
          continue
        fi
      ;;
    esac

  done < "$cArchivoConDatosACopiar"

# Loguear tarea
  echo "$cFechaDeEjec - Terminada la copia de seguridad interna." >> "$cArchivoDeLog"

# Notificar fin de ejecución del script
  echo ""
  echo "  Ejecución del script finalizada."
  echo ""

