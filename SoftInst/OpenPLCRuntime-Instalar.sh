mkdir -p /opt
cd /opt/
rm -rf /opt/OpenPLCRuntime
opkg update
opkg install git-http
git clone https://github.com/thiagoralves/OpenPLC_v3.git
cd /opt/OpenPLC_v3/
opkg install python3
opkg install python3-pip
pip3 install -r requirements.txt
sed -i -e 's-/bin/bash-/bin/sh-g' /opt/OpenPLC_v3/install.sh
