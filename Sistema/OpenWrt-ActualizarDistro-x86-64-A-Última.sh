#!/bin/sh

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------
#  Script de NiPeGun para actualizar la Distro completa
#--------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo -e "${ColorVerde}-----------------------------------------------------${FinColor}"
echo -e "${ColorVerde}  Iniciando el script de actualización de distro...${FinColor}"
echo -e "${ColorVerde}-----------------------------------------------------${FinColor}"
echo ""

## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
   if [ "$(opkg list-installed | grep wget)" = "" ]; then
     echo ""
     echo "  wget no está instalado. Iniciando su instalación..."
     echo ""
     opkg update
     opkg install wget
   fi

## Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
   if [ "$(opkg list-installed | grep -v libcurl | grep curl)" = "" ]; then
     echo ""
     echo "  curl no está instalado. Iniciando su instalación..."
     echo ""
     opkg update
     opkg install curl
   fi

## Comprobar si el router puede acceder a la web de OpenWrt antes de ejecutar el script
   wget -q --tries=10 --timeout=20 --spider https://openwrt.org
     if [[ $? -eq 0 ]]; then

       echo ""
       echo -e "${ColorVerde}  Determinando la versión instalada de la distro...${FinColor}"
       echo ""
       VersInstalada=$(cat /etc/opkg/distfeeds.conf | grep base | cut -d '/' -f 6)
       echo ""
       echo "  La versión de la distro actualmente instalada es la $VersInstalada"
       echo ""

       echo ""
       echo -e "${ColorVerde}  Buscando la última versión disponible...${FinColor}"
       echo ""
       UltVersOpenWrt=$(curl --silent https://downloads.openwrt.org/releases/ | grep -B 1 faillogs | grep -v faillogs | cut -d '"' -f 4 | sed 's/.$//')
       echo ""
       echo "  La última versión disponible es la $UltVersOpenWrt"
       echo ""

       echo ""
       echo -e "${ColorVerde}  Actualizando todos los paquetes de la versión $VersInstalada...${FinColor}"
       echo -e "${ColorVerde}  (Puede tardar hasta 20 minutos, déjalo terminar)${FinColor}"
       echo ""
       /root/scripts/o-scripts/OpenWrt-ActualizarPaquetes.sh > /dev/null

       echo ""
       echo -e "${ColorVerde}  Descargando el último kernel...${FinColor}"
       echo ""
       mv /boot/vmlinuz /boot/vmlinuz.old
       curl -R -o /boot/vmlinuz https://downloads.openwrt.org/releases/$UltVersOpenWrt/targets/x86/64/openwrt-$UltVersOpenWrt-x86-64-vmlinuz

       # Averiguar el nombre del archivo del último paquete del kernel
         PaqueteKernel=$(curl --silent https://downloads.openwrt.org/releases/$UltVersOpenWrt/targets/x86/64/packages/ | grep kernel | cut -d '"' -f 4)

       echo ""
       echo -e "${ColorVerde}  Descargando el archivo $PaqueteKernel...${FinColor}"
       echo ""
       mkdir -p /root/paquetes/kernel/ 2> /dev/null
       cd /root/paquetes/kernel/
       curl -R -O https://downloads.openwrt.org/releases/$UltVersOpenWrt/targets/x86/64/packages/$PaqueteKernel

       echo ""
       echo -e "${ColorVerde}  Instalando el archivo $PaqueteKernel...${FinColor}"
       echo ""
       opkg install /root/paquetes/kernel/$PaqueteKernel

       echo ""
       echo -e "${ColorVerde}  Modificando el archivo /etc/opkg/distfeeds.conf...${FinColor}"
       echo ""
       sed -i -e "s|$VersInstalada|$UltVersOpenWrt|g" /etc/opkg/distfeeds.conf
       echo ""
       echo "  El archivo /etc/opkg/distfeeds.conf ahora contiene los siguientes repos:"
       echo ""
       cat /etc/opkg/distfeeds.conf
       echo ""

       echo ""
       echo -e "${ColorVerde}  Actualizando la lista de paquetes de los repos recién indicados en /etc/opkg/distfeeds.conf...${FinColor}"
       echo ""
       opkg update

       echo ""
       echo -e "${ColorVerde}  Actualizando base-files...${FinColor}"
       echo ""
       # Quitar el permiso de ejecución al scripts de funciones para que el script de base-files no pueda ejecutarlo
         chmod -x /lib/functions.sh
         opkg upgrade base-files

       # Volver a indicar el servidor DNS
         echo "nameserver 127.0.0.1" > /etc/resolv.conf

       echo ""
       echo -e "${ColorVerde}  Actualizando todos los paquetes de la versión $UltVersOpenWrt...${FinColor}"
       echo -e "${ColorVerde}  (Puede tardar hasta 20 minutos, déjalo terminar)${FinColor}"
       echo ""
       /root/scripts/o-scripts/OpenWrt-ActualizarPaquetes.sh

       echo ""
       echo -e "${ColorVerde}---------------------------------------------------------------------------------${FinColor}"
       echo -e "${ColorVerde}  Script de actualización de distro, finalizado. Ya puedes reiniciar el router.${FinColor}"
       echo -e "${ColorVerde}---------------------------------------------------------------------------------${FinColor}"
       echo ""

     else

       echo ""
       echo -e "${ColorRojo}-------------------------------------------------------------------------------------------${FinColor}"
       echo -e "${ColorRojo}  No se completó la ejecución del script porque el router no puede acceder a openwrt.org.${FinColor}"
       echo -e "${ColorRojo}-------------------------------------------------------------------------------------------${FinColor}"
       echo ""

     fi

