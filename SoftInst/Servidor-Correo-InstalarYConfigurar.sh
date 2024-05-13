#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar netdata en OpenWrt
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/o-scripts/master/SoftInst/Servidor-Correop-InstalarYConfigurar.sh
# ----------

# Actualizar la lista de paquetes disponibles en los repositorios
  opkg update

# Instalar paquetes
  opkg install postfix
  opkg install dovecot

# Configurar Postfix
  sed -i -e 's|#myhostname = virtual.domain.tld|myhostname = mail.dominio.com|g'                                                                                 /etc/postfix/main.cf
  sed -i -e 's|#mydomain = domain.tld|mydomain = dominio.com|g'                                                                                                  /etc/postfix/main.cf
  sed -i -e 's|#myorigin = $mydomain|myorigin = $mydomain|g'                                                                                                     /etc/postfix/main.cf
  sed -i -e 's|#inet_interfaces = all|inet_interfaces = all|g'                                                                                                   /etc/postfix/main.cf
  sed -i -e 's|#mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain|mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain|g' /etc/postfix/main.cf
  sed -i -e 's|#mynetworks = 168.100.3.0/28, 127.0.0.0/8|mynetworks = 127.0.0.0/8, 10.5.0.0/24|g'                                                                /etc/postfix/main.cf
  sed -i -e 's|#home_mailbox = Maildir/|home_mailbox = Maildir/|g'                                                                                               /etc/postfix/main.cf

# Configurar Dovecot
  echo "mail_location = maildir:~/Maildir" >> /etc/dovecot/dovecot.conf
  echo "mail_location = maildir:~/Maildir" >> /etc/dovecot/dovecot.conf
  echo "service imap-login {"              >> /etc/dovecot/dovecot.conf
  echo "  inet_listener imap {"            >> /etc/dovecot/dovecot.conf
  echo "    port = 0"                      >> /etc/dovecot/dovecot.conf
  echo "  }"                               >> /etc/dovecot/dovecot.conf
  echo "  inet_listener imaps {"           >> /etc/dovecot/dovecot.conf
  echo "    port = 993"                    >> /etc/dovecot/dovecot.conf
  echo "    ssl = yes"                     >> /etc/dovecot/dovecot.conf
  echo "  }"                               >> /etc/dovecot/dovecot.conf
  echo "}"                                 >> /etc/dovecot/dovecot.conf

# Reiniciar servicios
  # Reiniciar postfix
    /etc/init.d/postfix restart
  # Reiniciar dovecot
    /etc/init.d/dovecot restart

