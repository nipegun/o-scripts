#!/bin/sh

# Ejecución remota:
#  curl -sL x | sh
#

vViejo='alpine-nginx'
vNuevo='alpine-nginx-web'
vLXCPath='/mnt/nvme/lxc/containers'

lxc-stop -P "$vLXCPath" -n "$vViejo"

lxc-copy -P "$vLXCPath" -n "$vViejo" -N "$vNuevo" -R

vSeccion="$(uci show lxc-auto | sed -n "s/^\(lxc-auto\.[^=]*\)\.name='$vViejo'$/\1/p" | head -n1)"

uci set "$vSeccion.name=$vNuevo"
uci commit lxc-auto

lxc-start -P "$vLXCPath" -n "$vNuevo"

