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

mkdir /root/nano/
cd /root/nano/

wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr"                                 /root/nano/usr
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/bin"                             /root/nano/usr/bin
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/bin/nano"                        /root/nano/usr/bin/nano
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib"                             /root/nano/usr/lib
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libmenu.so.5.9"              /root/nano/usr/lib/libmenu.so.5.9
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libmenu.so"                  /root/nano/usr/lib/libmenu.so
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libncurses.so.5.9"           /root/nano/usr/lib/libncurses.so.5.9
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libcurses.so"                /root/nano/usr/lib/libcurses.so
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libform.so.5"                /root/nano/usr/lib/libform.so.5
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libpanel.so"                 /root/nano/usr/lib/libpanel.so
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libpanel.so.5.9"             /root/nano/usr/lib/libpanel.so.5.9
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libform.so"                  /root/nano/usr/lib/libform.so
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libpanel.so.5"               /root/nano/usr/lib/libpanel.so.5
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libmenu.so.5"                /root/nano/usr/lib/libmenu.so.5
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libncurses.so.5"             /root/nano/usr/lib/libncurses.so.5
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libform.so.5.9"              /root/nano/usr/lib/libform.so.5.9
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/lib/libncurses.so"               /root/nano/usr/lib/libncurses.so
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share"                           /root/nano/usr/share
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo"                  /root/nano/usr/share/terminfo
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/v"                /root/nano/usr/share/terminfo/v
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/v/vt102"          /root/nano/usr/share/terminfo/v/vt102
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/v/vt100"          /root/nano/usr/share/terminfo/v/vt100
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/l"                /root/nano/usr/share/terminfo/l
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/l/linux"          /root/nano/usr/share/terminfo/l/linux
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/s"                /root/nano/usr/share/terminfo/s
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/s/screen"         /root/nano/usr/share/terminfo/s/screen
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/x"                /root/nano/usr/share/terminfo/x
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/x/xterm-color"    /root/nano/usr/share/terminfo/x/xterm-color
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/x/xterm"          /root/nano/usr/share/terminfo/x/xterm
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/x/xterm-256color" /root/nano/usr/share/terminfo/x/xterm-256color
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/r"                /root/nano/usr/share/terminfo/r
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/r/rxvt"           /root/nano/usr/share/terminfo/r/rxvt
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/r/rxvt-unicode"   /root/nano/usr/share/terminfo/r/rxvt-unicode
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/a"                /root/nano/usr/share/terminfo/a
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/a/ansi"           /root/nano/usr/share/terminfo/a/ansi
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/d"                /root/nano/usr/share/terminfo/d
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/usr/share/terminfo/d/dumb"           /root/nanousr/share/terminfo/d/dumb
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib"                                 /root/nano/lib
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/libdl-0.9.33.2.so"               /root/nano/lib/libdl-0.9.33.2.so
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/libutil.so.0"                    /root/nano/lib/libutil.so.0
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/libuClibc-0.9.33.2.so"           /root/nano/lib/libuClibc-0.9.33.2.so
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/libc.so.0"                       /root/nano/lib/libc.so.0
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/ld-uClibc-0.9.33.2.so"           /root/nano/lib/ld-uClibc-0.9.33.2.so
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/libdl.so.0"                      /root/nano/lib/libdl.so.0
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/libcrypt-0.9.33.2.so"            /root/nano/lib/libcrypt-0.9.33.2.so
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/libm-0.9.33.2.so"                /root/nano/lib/libm-0.9.33.2.so
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/libcrypt.so.0"                   /root/nano/lib/libcrypt.so.0
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/ld-uClibc.so.0"                  /root/nano/lib/ld-uClibc.so.0
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/libm.so.0"                       /root/nano/lib/libm.so.0
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/libutil-0.9.33.2.so"             /root/nano/lib/libutil-0.9.33.2.so
wget "http://hacks4geeks.com/_/premium/descargas/sfplantiq/nano/lib/libgcc_s.so.1"                   /root/nano/lib/libgcc_s.so.1

