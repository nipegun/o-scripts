#!/bin/sh

set -e

# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/o-scripts/refs/heads/master/SoftInst/LXC-Contenedor-Crear-Alpine-stalwart-github.sh | sh

vCarpetaLXC='/mnt/nvme/lxc'

vNombreDelContenedor='stalwart'
vAlpineVers='3.23'
vAlpineArch='arm64'

vIPv4Contenedor='10.10.4.3'
vIPv4Gateway='10.10.4.1'
vPrefijoStalwart='/opt/stalwart'

echo ''
echo '### Deteniendo contenedor anterior si existe'
lxc-stop -n "$vNombreDelContenedor" 2>/dev/null || true

echo ''
echo '### Eliminando contenedor anterior si existe'
rm -rf "$vCarpetaLXC"/containers/"$vNombreDelContenedor"

echo ''
echo '### Creando contenedor Alpine'
lxc-create -n "$vNombreDelContenedor" -t download -- --dist alpine --release "$vAlpineVers" --arch "$vAlpineArch"

echo ''
echo '### Configurando red LXC del contenedor'
echo "lxc.net.0.ipv4.address = $vIPv4Contenedor/24" >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/config
echo "lxc.net.0.ipv4.gateway = $vIPv4Gateway"       >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/config

echo ''
echo '### Configurando red dentro de Alpine'
echo 'auto lo'                                      > "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/network/interfaces
echo 'iface lo inet loopback'                      >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/network/interfaces
echo ''                                            >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/network/interfaces
echo 'auto eth0'                                   >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/network/interfaces
echo 'iface eth0 inet static'                      >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/network/interfaces
echo "  address $vIPv4Contenedor"                  >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/network/interfaces
echo '  netmask 255.255.255.0'                     >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/network/interfaces
echo "  gateway $vIPv4Gateway"                     >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/network/interfaces

echo ''
echo '### Iniciando contenedor'
lxc-start -n "$vNombreDelContenedor"

echo ''
echo '### Configurando DNS del contenedor'
rm -f "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/resolv.conf
echo 'nameserver 9.9.9.9' > "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/resolv.conf

echo ''
echo '### Actualizando índices APK'
lxc-attach -n "$vNombreDelContenedor" -- apk -v update

echo ''
echo '### Instalando dependencias base en Alpine'
lxc-attach -n "$vNombreDelContenedor" -- apk -v add --no-cache openrc shadow curl ca-certificates libcap openssh-server nano

echo ''
echo '### Actualizando certificados CA'
lxc-attach -n "$vNombreDelContenedor" -- update-ca-certificates

echo ''
echo '### Descargando instalador oficial de Stalwart'
lxc-attach -n "$vNombreDelContenedor" -- curl -s --location --fail --proto '=https' --tlsv1.2 https://get.stalw.art/install.sh -o /tmp/stalwart-install.sh

echo ''
echo '### Dando permisos de ejecución al instalador'
lxc-attach -n "$vNombreDelContenedor" -- chmod +x /tmp/stalwart-install.sh

echo ''
echo '### Instalando Stalwart desde GitHub/releases'
lxc-attach -n "$vNombreDelContenedor" -- sh /tmp/stalwart-install.sh "$vPrefijoStalwart"

echo ''
echo '### Comprobando binario de Stalwart'
lxc-attach -n "$vNombreDelContenedor" -- test -x "$vPrefijoStalwart"/bin/stalwart

echo ''
echo '### Deteniendo Stalwart si el instalador oficial lo dejó iniciado'
lxc-attach -n "$vNombreDelContenedor" -- /bin/sh -c 'rc-service stalwart stop 2>/dev/null || true'

echo ''
echo '### Eliminando servicio SysV incompatible generado por el instalador'
lxc-attach -n "$vNombreDelContenedor" -- rm -fv /etc/init.d/stalwart

echo ''
echo '### Aplicando capability para permitir puertos bajos sin root'
lxc-attach -n "$vNombreDelContenedor" -- setcap 'cap_net_bind_service=+ep' "$vPrefijoStalwart"/bin/stalwart

# WIZARD: Eliminamos cualquier config.json que el instalador oficial haya podido dejar.
#         Si existe config.json, Stalwart NO entra en bootstrap mode y NO sale el wizard.
echo ''
echo '### WIZARD: Borrando config.json para forzar bootstrap mode en el primer arranque'
lxc-attach -n "$vNombreDelContenedor" -- rm -fv "$vPrefijoStalwart"/etc/config.json
lxc-attach -n "$vNombreDelContenedor" -- rm -fv "$vPrefijoStalwart"/etc/config.toml

echo ''
echo '### Creando wrapper OpenRC para Stalwart'
echo '#!/bin/sh'                                                                                       > "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/opt/stalwart/bin/stalwart-openrc-wrapper.sh
echo ''                                                                                               >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/opt/stalwart/bin/stalwart-openrc-wrapper.sh
echo "if [ -r '$vPrefijoStalwart/etc/stalwart.env' ]; then"                                           >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/opt/stalwart/bin/stalwart-openrc-wrapper.sh
echo '  set -a'                                                                                       >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/opt/stalwart/bin/stalwart-openrc-wrapper.sh
echo "  . '$vPrefijoStalwart/etc/stalwart.env'"                                                       >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/opt/stalwart/bin/stalwart-openrc-wrapper.sh
echo '  set +a'                                                                                       >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/opt/stalwart/bin/stalwart-openrc-wrapper.sh
echo 'fi'                                                                                             >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/opt/stalwart/bin/stalwart-openrc-wrapper.sh
echo ''                                                                                               >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/opt/stalwart/bin/stalwart-openrc-wrapper.sh
echo 'ulimit -n 65536'                                                                                >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/opt/stalwart/bin/stalwart-openrc-wrapper.sh
# WIZARD: Llamamos al binario SIN --config para que Stalwart use su ruta por defecto
#         ($vPrefijoStalwart/etc/config.json). Como acabamos de borrarlo, entrará en
#         bootstrap mode y servirá el wizard en :8080. Tras completarlo, Stalwart
#         escribirá el config.json definitivo en esa misma ruta y reiniciará.
echo "exec '$vPrefijoStalwart/bin/stalwart'"                                                          >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/opt/stalwart/bin/stalwart-openrc-wrapper.sh

echo ''
echo '### Corrigiendo permisos del wrapper OpenRC'
lxc-attach -n "$vNombreDelContenedor" -- chmod +x "$vPrefijoStalwart"/bin/stalwart-openrc-wrapper.sh
lxc-attach -n "$vNombreDelContenedor" -- chown stalwart:stalwart "$vPrefijoStalwart"/bin/stalwart-openrc-wrapper.sh

echo ''
echo '### Creando servicio OpenRC nativo'
echo '#!/sbin/openrc-run'                                                               > "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/init.d/stalwart
echo ''                                                                                >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/init.d/stalwart
echo 'name="stalwart"'                                                                 >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/init.d/stalwart
echo 'description="Stalwart Mail Server"'                                              >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/init.d/stalwart
echo "command=\"$vPrefijoStalwart/bin/stalwart-openrc-wrapper.sh\""                    >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/init.d/stalwart
echo 'command_user="stalwart:stalwart"'                                                >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/init.d/stalwart
echo 'command_background="yes"'                                                        >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/init.d/stalwart
echo 'pidfile="/run/stalwart.pid"'                                                     >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/init.d/stalwart
echo "directory=\"$vPrefijoStalwart/data\""                                            >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/init.d/stalwart
echo "output_log=\"$vPrefijoStalwart/logs/stalwart.log\""                              >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/init.d/stalwart
echo "error_log=\"$vPrefijoStalwart/logs/stalwart.log\""                               >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/init.d/stalwart
echo 'start_stop_daemon_args="--make-pidfile"'                                         >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/init.d/stalwart
echo ''                                                                                >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/init.d/stalwart
echo 'depend() {'                                                                      >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/init.d/stalwart
echo '  need net'                                                                      >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/init.d/stalwart
echo '}'                                                                               >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/init.d/stalwart
echo ''                                                                                >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/init.d/stalwart
echo 'start_pre() {'                                                                   >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/init.d/stalwart
echo "  checkpath -d -m 0750 -o stalwart:stalwart $vPrefijoStalwart/data"              >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/init.d/stalwart
echo "  checkpath -d -m 0750 -o stalwart:stalwart $vPrefijoStalwart/logs"              >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/init.d/stalwart
echo "  checkpath -d -m 0750 -o stalwart:stalwart $vPrefijoStalwart/etc"               >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/init.d/stalwart
echo "  checkpath -f -m 0640 -o stalwart:stalwart $vPrefijoStalwart/logs/stalwart.log" >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/init.d/stalwart
echo '}'                                                                               >> "$vCarpetaLXC"/containers/"$vNombreDelContenedor"/rootfs/etc/init.d/stalwart

echo ''
echo '### Corrigiendo permisos del servicio OpenRC'
lxc-attach -n "$vNombreDelContenedor" -- chmod +x /etc/init.d/stalwart
lxc-attach -n "$vNombreDelContenedor" -- chown root:root /etc/init.d/stalwart

echo ''
echo '### Generando contraseña admin aleatoria para el wizard'
vPassAdmin=$(lxc-attach -n "$vNombreDelContenedor" -- /bin/sh -c "head -c 18 /dev/urandom | base64 | tr -d '/+='")

# WIZARD: NO usamos STALWART_RECOVERY_MODE=true (eso desactiva el wizard).
#         Solo AÑADIMOS STALWART_RECOVERY_ADMIN al stalwart.env que ya creó el
#         instalador oficial (que contiene CONFIG_PATH y otras variables necesarias
#         para que el binario sepa dónde buscar/crear su config.json). Usamos >>
#         (NO >) para preservar lo que ya hay dentro.
echo ''
echo '### WIZARD: Añadiendo credencial temporal de admin para el bootstrap'
lxc-attach -n "$vNombreDelContenedor" -- /bin/sh -c "echo 'STALWART_RECOVERY_ADMIN=admin:$vPassAdmin' >> '$vPrefijoStalwart/etc/stalwart.env'"

lxc-attach -n "$vNombreDelContenedor" -- chmod 0600 "$vPrefijoStalwart"/etc/stalwart.env
lxc-attach -n "$vNombreDelContenedor" -- chown stalwart:stalwart "$vPrefijoStalwart"/etc/stalwart.env

echo ''
echo '### Mostrando contenido de stalwart.env (sin la contraseña) para diagnóstico'
lxc-attach -n "$vNombreDelContenedor" -- /bin/sh -c "grep -v 'STALWART_RECOVERY_ADMIN' '$vPrefijoStalwart/etc/stalwart.env' || true"

echo ''
echo '### Iniciando Stalwart con OpenRC (entrará en bootstrap mode al no haber config.json)'
lxc-attach -n "$vNombreDelContenedor" -- rc-service stalwart start

echo ''
echo '### Habilitando Stalwart al arranque'
lxc-attach -n "$vNombreDelContenedor" -- rc-update add stalwart default

echo ''
echo '### Mostrando versión instalada'
lxc-attach -n "$vNombreDelContenedor" -- "$vPrefijoStalwart"/bin/stalwart --version

echo ''
echo '### Mostrando estado del servicio'
lxc-attach -n "$vNombreDelContenedor" -- rc-service stalwart status || true

echo ''
echo '### Diagnóstico: últimas 40 líneas del log de Stalwart (si existe)'
lxc-attach -n "$vNombreDelContenedor" -- /bin/sh -c "tail -n 40 '$vPrefijoStalwart/logs/stalwart.log' 2>/dev/null || echo '(log vacío o aún no creado)'"

echo ''
echo '### Diagnóstico: si crasheó, ejecutarlo manualmente para capturar el error'
lxc-attach -n "$vNombreDelContenedor" -- /bin/sh -c "rc-service stalwart status 2>&1 | grep -q crashed && {
  echo '--- Lanzando stalwart en foreground (5s) para ver el error real ---'
  su stalwart -s /bin/sh -c '. $vPrefijoStalwart/etc/stalwart.env; timeout 5 $vPrefijoStalwart/bin/stalwart 2>&1 | head -n 30' || true
} || true"

echo ''
echo '  ============================================================'
echo '  Stalwart está en BOOTSTRAP MODE. Entra en:'
echo "    http://$vIPv4Contenedor:8080/admin"
echo '    Usuario: admin'
echo "    Contraseña: $vPassAdmin"
echo ''
echo '  El wizard te guiará paso a paso (incluye configuración de'
echo '  la base de datos). Al completarlo, Stalwart escribirá su'
echo '  config.json definitivo y se reiniciará en modo normal.'
echo ''
echo '  Tras el reinicio el acceso administrativo se moverá a:'
echo '    https://<hostname-que-elijas-en-el-wizard>/admin'
echo '  (puerto 443 vía HTTPS; el :8080 ya no será válido).'
echo ''
echo '  Después del wizard puedes eliminar la credencial temporal:'
echo "    lxc-attach -n $vNombreDelContenedor -- sed -i '/^STALWART_RECOVERY_ADMIN=/d' $vPrefijoStalwart/etc/stalwart.env"
echo "    lxc-attach -n $vNombreDelContenedor -- rc-service stalwart restart"
echo '  ============================================================'

echo ''
echo '  Instalación de Stalwart Mail Server desde GitHub/releases, finalizada.'
echo ''
echo '  Para parar el contenedor:'
echo "    lxc-stop -n \"$vNombreDelContenedor\""
echo ''
echo '  Para reiniciar el contenedor:'
echo "    lxc-start -n \"$vNombreDelContenedor\""
echo ''
echo '  Para entrar al contenedor:'
echo "    lxc-attach -n \"$vNombreDelContenedor\" -- /bin/sh"
echo ''
echo ''
