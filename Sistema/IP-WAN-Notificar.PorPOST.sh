#!/bin/sh

vIPWAN=$(curl -sL ifconfig.me)
vDestinoPOST='xx1'
vFQDNorigen="xx2"
vURLRecepc="xx3"

curl -X POST -d "fqdn=$vFQDNorigen&ip=$vIPWAN" "$vURLRecepc"

