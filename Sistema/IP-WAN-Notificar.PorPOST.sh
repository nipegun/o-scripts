#!/bin/sh

vIPWAN=$(curl -sL ifconfig.me)
vDestinoPOST='xxx'
vHostName="$(cat /proc/sys/kernel/hostname)"
vCliente="$(cat /root/cliente.txt)"

curl -X POST -d "fqdn=$vHostName.$vCliente&ip=$vIPWAN" "$vURLRecepc"

echo ''
echo "  Se ha enviado un post a $vDestinoPOST con los siguientes datos:"
echo ''
echo "    fqdn=$vHostName.$vCliente ip=$vIPWAN"
echo ''
