#!/bin/sh

vIPWAN=$(curl -sL ifconfig.me)

echo "La IP WAN es $vIPWAN"
