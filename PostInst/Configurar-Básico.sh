
          sudo rm -f                                                                                                /OpenWrt/PartExt4/etc/config/adblock
          sudo wget https://raw.githubusercontent.com/nipegun/o-scripts/master/Recursos/Conf0/etc/config/adblock -O /OpenWrt/PartExt4/etc/config/adblock
          sudo rm -f                                                                                             /OpenWrt/PartExt4/etc/config/dhcp
          sudo wget https://raw.githubusercontent.com/nipegun/o-scripts/master/Recursos/Conf0/etc/config/dhcp -O /OpenWrt/PartExt4/etc/config/dhcp
          sudo rm -f                                                                                                 /OpenWrt/PartExt4/etc/config/firewall
          sudo wget https://raw.githubusercontent.com/nipegun/o-scripts/master/Recursos/Conf0/etc/config/firewall -O /OpenWrt/PartExt4/etc/config/firewall
          sudo rm -f                                                                                                /OpenWrt/PartExt4/etc/config/network
          sudo wget https://raw.githubusercontent.com/nipegun/o-scripts/master/Recursos/Conf0/etc/config/network -O /OpenWrt/PartExt4/etc/config/network
          sudo rm -f                                                                                                 /OpenWrt/PartExt4/etc/config/wireless
          sudo wget https://raw.githubusercontent.com/nipegun/o-scripts/master/Recursos/Conf0/etc/config/wireless -O /OpenWrt/PartExt4/etc/config/wireless

          sudo mkdir /OpenWrt/PartEFI/scripts/ 2> /dev/null
          sudo rm -rf                               /OpenWrt/PartExt4/etc/config/network
          sudo cp /OpenWrt/PartEFI/scripts/network /OpenWrt/PartExt4/etc/config
