#!/bin/sh

# Script de NiPeGun para calcular la fecha en OpenWrt sacando el formato nipeguniano con milisegundos (ejemplo: a2025m11d07h00m07s00ms725)
#  Requisitos: paquete coreutils-date

vFecha=$(date +"a%Ym%md%dh%Hm%Ms%S%3N" | sed 's/\([0-9]\{3\}\)$/ms\1/')
echo "$vFecha"
