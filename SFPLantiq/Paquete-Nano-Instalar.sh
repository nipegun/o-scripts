#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para descargar los archivos correspondientes a nano en el OpenWrt del SFP Lantiq con OpenWrt 14.07
#
# Ejecución remota:
#   curl -s https://raw.githubusercontent.com/nipegun/o-scripts/master/SFPLantiq/Paquete-Nano-DescargarArchivos.sh | sh
# ----------

# Crear carpetas
  mkdir /root/nano/                     2> /dev/null
  mkdir /root/nano/usr                  2> /dev/null
  mkdir /root/nano/usr/bin              2> /dev/null
  mkdir /root/nano/usr/lib              2> /dev/null
  mkdir /root/nano/usr/share            2> /dev/null
  mkdir /root/nano/usr/share/terminfo   2> /dev/null
  mkdir /root/nano/usr/share/terminfo/v 2> /dev/null
  mkdir /root/nano/usr/share/terminfo/l 2> /dev/null
  mkdir /root/nano/usr/share/terminfo/s 2> /dev/null
  mkdir /root/nano/usr/share/terminfo/x 2> /dev/null
  mkdir /root/nano/usr/share/terminfo/r 2> /dev/null
  mkdir /root/nano/usr/share/terminfo/a 2> /dev/null
  mkdir /root/nano/usr/share/terminfo/d 2> /dev/null
  mkdir /root/nano/lib                  2> /dev/null

# Descargar archivos
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr"                                 -o /root/nano/usr
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/bin"                             -o /root/nano/usr/bin
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/bin/nano"                        -o /root/nano/usr/bin/nano
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib"                             -o /root/nano/usr/lib
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libmenu.so.5.9"              -o /root/nano/usr/lib/libmenu.so.5.9
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libmenu.so"                  -o /root/nano/usr/lib/libmenu.so
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libncurses.so.5.9"           -o /root/nano/usr/lib/libncurses.so.5.9
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libcurses.so"                -o /root/nano/usr/lib/libcurses.so
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libform.so.5"                -o /root/nano/usr/lib/libform.so.5
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libpanel.so"                 -o /root/nano/usr/lib/libpanel.so
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libpanel.so.5.9"             -o /root/nano/usr/lib/libpanel.so.5.9
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libform.so"                  -o /root/nano/usr/lib/libform.so
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libpanel.so.5"               -o /root/nano/usr/lib/libpanel.so.5
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libmenu.so.5"                -o /root/nano/usr/lib/libmenu.so.5
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libncurses.so.5"             -o /root/nano/usr/lib/libncurses.so.5
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libform.so.5.9"              -o /root/nano/usr/lib/libform.so.5.9
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libncurses.so"               -o /root/nano/usr/lib/libncurses.so
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share"                           -o /root/nano/usr/share
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo"                  -o /root/nano/usr/share/terminfo
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/v"                -o /root/nano/usr/share/terminfo/v
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/v/vt102"          -o /root/nano/usr/share/terminfo/v/vt102
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/v/vt100"          -o /root/nano/usr/share/terminfo/v/vt100
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/l"                -o /root/nano/usr/share/terminfo/l
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/l/linux"          -o /root/nano/usr/share/terminfo/l/linux
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/s"                -o /root/nano/usr/share/terminfo/s
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/s/screen"         -o /root/nano/usr/share/terminfo/s/screen
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/x"                -o /root/nano/usr/share/terminfo/x
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/x/xterm-color"    -o /root/nano/usr/share/terminfo/x/xterm-color
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/x/xterm"          -o /root/nano/usr/share/terminfo/x/xterm
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/x/xterm-256color" -o /root/nano/usr/share/terminfo/x/xterm-256color
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/r"                -o /root/nano/usr/share/terminfo/r
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/r/rxvt"           -o /root/nano/usr/share/terminfo/r/rxvt
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/r/rxvt-unicode"   -o /root/nano/usr/share/terminfo/r/rxvt-unicode
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/a"                -o /root/nano/usr/share/terminfo/a
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/a/ansi"           -o /root/nano/usr/share/terminfo/a/ansi
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/d"                -o /root/nano/usr/share/terminfo/d
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/d/dumb"           -o /root/nano/usr/share/terminfo/d/dumb
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib"                                 -o /root/nano/lib
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/libdl-0.9.33.2.so"               -o /root/nano/lib/libdl-0.9.33.2.so
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/libutil.so.0"                    -o /root/nano/lib/libutil.so.0
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/libuClibc-0.9.33.2.so"           -o /root/nano/lib/libuClibc-0.9.33.2.so
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/libc.so.0"                       -o /root/nano/lib/libc.so.0
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/ld-uClibc-0.9.33.2.so"           -o /root/nano/lib/ld-uClibc-0.9.33.2.so
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/libdl.so.0"                      -o /root/nano/lib/libdl.so.0
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/libcrypt-0.9.33.2.so"            -o /root/nano/lib/libcrypt-0.9.33.2.so
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/libm-0.9.33.2.so"                -o /root/nano/lib/libm-0.9.33.2.so
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/libcrypt.so.0"                   -o /root/nano/lib/libcrypt.so.0
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/ld-uClibc.so.0"                  -o /root/nano/lib/ld-uClibc.so.0
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/libm.so.0"                       -o /root/nano/lib/libm.so.0
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/libutil-0.9.33.2.so"             -o /root/nano/lib/libutil-0.9.33.2.so
  curl -sL "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/libgcc_s.so.1"                   -o /root/nano/lib/libgcc_s.so.1

# Asignar permisos de ejecución a binarios
  chmod +x /root/nano/usr/bin/nano

# Crear script para agregar correctamente los enlaces simbólicos
  echo '#!/bin/sh'                                      > /root/CorregirEnlaces-nano.sh
  echo ""                                              >> /root/CorregirEnlaces-nano.sh
  echo 'cd /lib/'                                      >> /root/CorregirEnlaces-nano.sh
  echo "  ln -sf ld-uClibc-0.9.33.2.so ld-uClibc.so.0" >> /root/CorregirEnlaces-nano.sh
  echo "  ln -sf ld-uClibc-0.9.33.2.so libc.so.0"      >> /root/CorregirEnlaces-nano.sh
  echo "  ln -sf libcrypt-0.9.33.2.so  libcrypt.so.0"  >> /root/CorregirEnlaces-nano.sh
  echo "  ln -sf libdl-0.9.33.2.so     libdl.so.0"     >> /root/CorregirEnlaces-nano.sh
  echo "  ln -sf libm-0.9.33.2.so      libm.so.0"      >> /root/CorregirEnlaces-nano.sh
  echo "  ln -sf libutil-0.9.33.2.so   libutil.so.0"   >> /root/CorregirEnlaces-nano.sh
  echo 'cd /usr/lib/'                                  >> /root/CorregirEnlaces-nano.sh
  echo "  ln -sf libcurses.so.5.9  libcurses.so"       >> /root/CorregirEnlaces-nano.sh
  echo "  ln -sf libform.so.5      libform.so"         >> /root/CorregirEnlaces-nano.sh
  echo "  ln -sf libform.so.5.9    libform.so.5"       >> /root/CorregirEnlaces-nano.sh
  echo "  ln -sf libmenu.so.5      libmenu.so"         >> /root/CorregirEnlaces-nano.sh
  echo "  ln -sf libmenu.so.5.9    libmenu.so.5"       >> /root/CorregirEnlaces-nano.sh
  echo "  ln -sf libncurses.so.5   libncurses.so"      >> /root/CorregirEnlaces-nano.sh
  echo "  ln -sf libncurses.so.5.9 libncurses.so.5"    >> /root/CorregirEnlaces-nano.sh
  echo "  ln -sf libpanel.so.5     libpanel.so"        >> /root/CorregirEnlaces-nano.sh
  echo "  ln -sf libpanel.so.5.9   libpanel.so.5"      >> /root/CorregirEnlaces-nano.sh
  chmod +x                                                /root/CorregirEnlaces-nano.sh



# Notificar fin de ejecución del script
  echo ""
  echo "  Ejecución del script, finalizada."
  echo ""
  echo "    Para corregir los enlaces simbólicos, debes ejecutar:"
  echo ""
  echo "      /root/CorregirEnlaces-nano.sh"

