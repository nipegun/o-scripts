#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------
#  Script de NiPeGun para configurar WiFi en OpenWrt 21 
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/o-scripts/master/WiFi-Configurar.sh | bash
#-------------------------------------------------------

echo ""
echo "  Re-configurando el WiFi..."
echo ""

# Configurar WiFi
  echo "config wifi-device 'radio0'"                           > /etc/config/wireless
  echo "  option type 'mac80211'"                             >> /etc/config/wireless
  echo "  option path 'pci0000:00/0000:00:1c.0/0000:01:00.0'" >> /etc/config/wireless
  echo "  option band '2g'"                                   >> /etc/config/wireless
  echo "  option htmode 'HT20'"                               >> /etc/config/wireless
  echo "  option channel 'auto'"                              >> /etc/config/wireless
  echo "  option cell_density '0'"                            >> /etc/config/wireless
  echo "  option country 'ES'"                                >> /etc/config/wireless
  echo ""                                                     >> /etc/config/wireless
  echo "config wifi-device 'radio1'"                          >> /etc/config/wireless
  echo "  option type 'mac80211'"                             >> /etc/config/wireless
  echo "  option path 'pci0000:00/0000:00:1c.0/0000:02:00.0'" >> /etc/config/wireless
  echo "  option band '5g'"                                   >> /etc/config/wireless
  echo "  option htmode 'VHT80'"                              >> /etc/config/wireless
  echo "  option channel 'auto'"                              >> /etc/config/wireless
  echo "  option cell_density '0'"                            >> /etc/config/wireless
  echo "  option country 'ES'"                                >> /etc/config/wireless
  echo ""                                                     >> /etc/config/wireless
  echo "config wifi-iface 'default_radio0'"                   >> /etc/config/wireless
  echo "  option ifname 'wlan0'"                              >> /etc/config/wireless
  echo "  option device 'radio0'"                             >> /etc/config/wireless
  echo "  option mode 'ap'"                                   >> /etc/config/wireless
  echo "  option ssid 'OpenWrt'"                              >> /etc/config/wireless
  echo "  option encryption 'sae-mixed'"                      >> /etc/config/wireless
  echo "  option key 'Conectar0'"                             >> /etc/config/wireless
  echo "  option isolate '0'"                                 >> /etc/config/wireless
  echo "  option network 'i_lan'"                             >> /etc/config/wireless
  echo "  option disabled '0'"                                >> /etc/config/wireless
  echo ""                                                     >> /etc/config/wireless
  echo "config wifi-iface 'default_radio1'"                   >> /etc/config/wireless
  echo "  option ifname 'wlan1'"                              >> /etc/config/wireless
  echo "  option device 'radio1'"                             >> /etc/config/wireless
  echo "  option mode 'ap'"                                   >> /etc/config/wireless
  echo "  option ssid 'OpenWrt'"                              >> /etc/config/wireless
  echo "  option encryption 'sae-mixed'"                      >> /etc/config/wireless
  echo "  option key 'Conectar0'"                             >> /etc/config/wireless
  echo "  option isolate '0'"                                 >> /etc/config/wireless
  echo "  option network 'i_lan'"                             >> /etc/config/wireless
  echo "  option disabled '0'"                                >> /etc/config/wireless
  echo ""                                                     >> /etc/config/wireless
  echo "config wifi-iface 'inv_radio0'"                       >> /etc/config/wireless
  echo "  option ifname 'wlan0_1'"                            >> /etc/config/wireless
  echo "  option device 'radio0'"                             >> /etc/config/wireless
  echo "  option mode 'ap'"                                   >> /etc/config/wireless
  echo "  option ssid 'Invitadoss'"                            >> /etc/config/wireless
  echo "  option encryption 'sae-mixed'"                      >> /etc/config/wireless
  echo "  option key 'Conectar0'"                             >> /etc/config/wireless
  echo "  option isolate '1'"                                 >> /etc/config/wireless
  echo "  option network 'i_inv'"                             >> /etc/config/wireless
  echo "  option disabled '0'"                                >> /etc/config/wireless
  echo ""                                                     >> /etc/config/wireless
  echo "config wifi-iface 'inv_radio1'"                       >> /etc/config/wireless
  echo "  option ifname 'wlan1_1'"                            >> /etc/config/wireless
  echo "  option device 'radio1'"                             >> /etc/config/wireless
  echo "  option mode 'ap'"                                   >> /etc/config/wireless
  echo "  option ssid 'Invitadoss'"                            >> /etc/config/wireless
  echo "  option encryption 'sae-mixed'"                      >> /etc/config/wireless
  echo "  option key 'Conectar0'"                             >> /etc/config/wireless
  echo "  option isolate '1'"                                 >> /etc/config/wireless
  echo "  option network 'i_inv'"                             >> /etc/config/wireless
  echo "  option disabled '0'"                                >> /etc/config/wireless
  echo ""                                                     >> /etc/config/wireless
  echo "config wifi-iface 'iot_radio0'"                       >> /etc/config/wireless
  echo "  option ifname 'wlan0_2'"                            >> /etc/config/wireless
  echo "  option device 'radio0'"                             >> /etc/config/wireless
  echo "  option mode 'ap'"                                   >> /etc/config/wireless
  echo "  option ssid 'IoT'"                                  >> /etc/config/wireless
  echo "  option encryption 'sae-mixed'"                      >> /etc/config/wireless
  echo "  option key 'Conectar0'"                             >> /etc/config/wireless
  echo "  option isolate '1'"                                 >> /etc/config/wireless
  echo "  option network 'i_iot'"                             >> /etc/config/wireless
  echo "  option disabled '0'"                                >> /etc/config/wireless
  echo ""                                                     >> /etc/config/wireless
  echo "config wifi-iface 'iot_radio1'"                       >> /etc/config/wireless
  echo "  option ifname 'wlan1_2'"                            >> /etc/config/wireless
  echo "  option device 'radio1'"                             >> /etc/config/wireless
  echo "  option mode 'ap'"                                   >> /etc/config/wireless
  echo "  option ssid 'IoT'"                                  >> /etc/config/wireless
  echo "  option encryption 'sae-mixed'"                      >> /etc/config/wireless
  echo "  option key 'Conectar0'"                             >> /etc/config/wireless
  echo "  option isolate '1'"                                 >> /etc/config/wireless
  echo "  option network 'i_iot'"                             >> /etc/config/wireless
  echo "  option disabled '0'"                                >> /etc/config/wireless
