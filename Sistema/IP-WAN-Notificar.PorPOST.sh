#!/bin/sh

vIPWAN=$(curl -sL ifconfig.me)
vDestinoPOST='xx'
vFQDNorigen="xxx"
vURLRecepc="xxxx"

curl -X POST -d "fqdn=$vFQDNorigen&ip=$vIPWAN" "$vURLRecepc"

