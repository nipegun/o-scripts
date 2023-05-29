# Jazztel


# Simyo
  echo "config interface 'wan'"        >> /etc/config/network
  echo "  option device 'br-wan.832'"  >> /etc/config/network
  echo "  option proto 'dhcp'"         >> /etc/config/network
  echo "  option hostname '*'"         >> /etc/config/network
  echo "  option delegate '0'"         >> /etc/config/network
  echo "  option peerdns '0'"          >> /etc/config/network
  echo "  list dns '9.9.9.9'"          >> /etc/config/network
  echo "  list dns '149.112.112.112'"  >> /etc/config/network
