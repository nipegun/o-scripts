#!/bin/sh

vIPWAN=$(curl -sL ifconfig.me)
vDestinoPOST='xx1'
vHostName="$(hostname)"
vCliente="$(cat /root/cliente.txt)"
vURLRecepc="xx3"

curl -X POST -d "fqdn=$vHostName.$vCliente&ip=$vIPWAN" "$vURLRecepc"

