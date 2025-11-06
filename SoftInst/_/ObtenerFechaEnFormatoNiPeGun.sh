#!/bin/sh

# Script de NiPeGun para calcular la fecha en OpenWrt sacando el formato nipeguniano
#  Requisitos: paquete coreutils-date

vFecha=$(date +"a%Ym%md%dh%Hm%Ms%S%3N" | sed 's/\([0-9]\{3\}\)$/ms\1/')
echo "$vFecha"
