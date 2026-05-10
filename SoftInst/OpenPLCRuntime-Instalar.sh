#1/bin/sh

# Script de NiPeGun para instalar OpenPLCRuntime directamente en OpenWrt
#
# Ejecución remota
#  cusl -sL https://raw.githubusercontent.com/nipegun/o-scripts/refs/heads/master/SoftInst/OpenPLCRuntime-Instalar.sh

mkdir -p /opt
cd /opt/
rm -rf /opt/OpenPLCRuntime
apk update
apk add git-http
git clone https://github.com/thiagoralves/OpenPLC_v3.git
cd /opt/OpenPLC_v3/
apk add python3
apk add python3-pip
pip3 install -r requirements.txt
sed -i -e 's-/bin/bash-/bin/sh-g' /opt/OpenPLC_v3/install.sh
