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

mkdir -o /root/nano/
cd -o /root/nano/

curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr"                                 -o /root/nano/usr
wget -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/bin"                             -o /root/nano/usr/bin
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/bin/nano"                        -o /root/nano/usr/bin/nano
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib"                             -o /root/nano/usr/lib
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libmenu.so.5.9"              -o /root/nano/usr/lib/libmenu.so.5.9
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libmenu.so"                  -o /root/nano/usr/lib/libmenu.so
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libncurses.so.5.9"           -o /root/nano/usr/lib/libncurses.so.5.9
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libcurses.so"                -o /root/nano/usr/lib/libcurses.so
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libform.so.5"                -o /root/nano/usr/lib/libform.so.5
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libpanel.so"                 -o /root/nano/usr/lib/libpanel.so
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libpanel.so.5.9"             -o /root/nano/usr/lib/libpanel.so.5.9
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libform.so"                  -o /root/nano/usr/lib/libform.so
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libpanel.so.5"               -o /root/nano/usr/lib/libpanel.so.5
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libmenu.so.5"                -o /root/nano/usr/lib/libmenu.so.5
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libncurses.so.5"             -o /root/nano/usr/lib/libncurses.so.5
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libform.so.5.9"              -o /root/nano/usr/lib/libform.so.5.9
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libncurses.so"               -o /root/nano/usr/lib/libncurses.so
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share"                           -o /root/nano/usr/share
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo"                  -o /root/nano/usr/share/terminfo
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/v"                -o /root/nano/usr/share/terminfo/v
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/v/vt102"          -o /root/nano/usr/share/terminfo/v/vt102
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/v/vt100"          -o /root/nano/usr/share/terminfo/v/vt100
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/l"                -o /root/nano/usr/share/terminfo/l
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/l/linux"          -o /root/nano/usr/share/terminfo/l/linux
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/s"                -o /root/nano/usr/share/terminfo/s
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/s/screen"         -o /root/nano/usr/share/terminfo/s/screen
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/x"                -o /root/nano/usr/share/terminfo/x
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/x/xterm-color"    -o /root/nano/usr/share/terminfo/x/xterm-color
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/x/xterm"          -o /root/nano/usr/share/terminfo/x/xterm
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/x/xterm-256color" -o /root/nano/usr/share/terminfo/x/xterm-256color
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/r"                -o /root/nano/usr/share/terminfo/r
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/r/rxvt"           -o /root/nano/usr/share/terminfo/r/rxvt
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/r/rxvt-unicode"   -o /root/nano/usr/share/terminfo/r/rxvt-unicode
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/a"                -o /root/nano/usr/share/terminfo/a
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/a/ansi"           -o /root/nano/usr/share/terminfo/a/ansi
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/d"                -o /root/nano/usr/share/terminfo/d
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/d/dumb"           -o /root/nano/usr/share/terminfo/d/dumb
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib"                                 -o /root/nano/lib
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/libdl-0.9.33.2.so"               -o /root/nano/lib/libdl-0.9.33.2.so
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/libutil.so.0"                    -o /root/nano/lib/libutil.so.0
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/libuClibc-0.9.33.2.so"           -o /root/nano/lib/libuClibc-0.9.33.2.so
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/libc.so.0"                       -o /root/nano/lib/libc.so.0
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/ld-uClibc-0.9.33.2.so"           -o /root/nano/lib/ld-uClibc-0.9.33.2.so
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/libdl.so.0"                      -o /root/nano/lib/libdl.so.0
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/libcrypt-0.9.33.2.so"            -o /root/nano/lib/libcrypt-0.9.33.2.so
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/libm-0.9.33.2.so"                -o /root/nano/lib/libm-0.9.33.2.so
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/libcrypt.so.0"                   -o /root/nano/lib/libcrypt.so.0
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/ld-uClibc.so.0"                  -o /root/nano/lib/ld-uClibc.so.0
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/libm.so.0"                       -o /root/nano/lib/libm.so.0
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/libutil-0.9.33.2.so"             -o /root/nano/lib/libutil-0.9.33.2.so
curl -L "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/libgcc_s.so.1"                   -o /root/nano/lib/libgcc_s.so.1

