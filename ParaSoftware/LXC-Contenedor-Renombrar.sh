#!/bin/sh

# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/o-scripts/refs/heads/master/ParaSoftware/LXC-Contenedor-Renombrar.sh | sh

cLXCPath="/mnt/nvme/lxc/containers"

fMostrarUso() {
  echo "Uso:"
  echo "  $0 <nombre-viejo> <nombre-nuevo>"
  echo
  echo "Ejemplo:"
  echo "  $0 alpine-nginx alpine-nginx-web"
}

fValidarNombre() {
  vNombre="$1"

  case "$vNombre" in
    "")
      echo "ERROR: El nombre no puede estar vacío."
      exit 1
    ;;
    *[!abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_.-]*)
      echo "ERROR: Nombre inválido: $vNombre"
      echo "Usa solo letras, números, guiones, guiones bajos y puntos."
      exit 1
    ;;
  esac
}

if [ "$#" -ne 2 ]; then
  fMostrarUso
  exit 1
fi

vNombreViejo="$1"
vNombreNuevo="$2"

fValidarNombre "$vNombreViejo"
fValidarNombre "$vNombreNuevo"

if [ "$vNombreViejo" = "$vNombreNuevo" ]; then
  echo "ERROR: El nombre viejo y el nombre nuevo son iguales."
  exit 1
fi

if [ ! -d "$cLXCPath/$vNombreViejo" ]; then
  echo "ERROR: No existe el contenedor:"
  echo "  $cLXCPath/$vNombreViejo"
  exit 1
fi

if [ -e "$cLXCPath/$vNombreNuevo" ]; then
  echo "ERROR: Ya existe un contenedor con el nombre nuevo:"
  echo "  $cLXCPath/$vNombreNuevo"
  exit 1
fi

vEstado="$(lxc-info -P "$cLXCPath" -n "$vNombreViejo" -s -H 2>/dev/null)"

if [ "$vEstado" = "RUNNING" ]; then
  echo "Deteniendo contenedor:"
  echo "  $vNombreViejo"

  lxc-stop -P "$cLXCPath" -n "$vNombreViejo"

  if [ "$?" -ne 0 ]; then
    echo "ERROR: No se pudo detener el contenedor."
    exit 1
  fi
fi

echo "Renombrando contenedor:"
echo "  $vNombreViejo -> $vNombreNuevo"

lxc-copy -P "$cLXCPath" -n "$vNombreViejo" -N "$vNombreNuevo" -R

if [ "$?" -ne 0 ]; then
  echo "ERROR: No se pudo renombrar el contenedor con lxc-copy."
  exit 1
fi

vSeccion="$(uci show lxc-auto 2>/dev/null | grep ".name='$vNombreViejo'" | cut -d. -f1,2 | sed -n '1p')"

if [ -n "$vSeccion" ]; then
  echo "Actualizando autostart en UCI:"
  echo "  $vSeccion.name=$vNombreNuevo"

  uci set "$vSeccion.name=$vNombreNuevo"
  uci commit lxc-auto

  if [ "$?" -ne 0 ]; then
    echo "ERROR: No se pudo actualizar lxc-auto."
    exit 1
  fi
else
  echo "AVISO: No se encontró entrada en lxc-auto para:"
  echo "  $vNombreViejo"
fi

if [ "$vEstado" = "RUNNING" ]; then
  echo "Arrancando contenedor renombrado:"
  echo "  $vNombreNuevo"

  lxc-start -P "$cLXCPath" -n "$vNombreNuevo"

  if [ "$?" -ne 0 ]; then
    echo "ERROR: El contenedor fue renombrado, pero no se pudo arrancar."
    exit 1
  fi
fi

echo "Contenedor renombrado correctamente."
echo
lxc-ls -P "$cLXCPath" -f
