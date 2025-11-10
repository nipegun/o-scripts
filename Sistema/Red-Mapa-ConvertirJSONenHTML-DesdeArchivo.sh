#!/bin/sh

# Convierte el JSON agrupado del mapa de red en HTML
# Requiere jq (instalado en OpenWrt)

# Verificar argumento
if [ -z "$1" ]; then
  echo "Uso: $0 archivo.json" >&2
  exit 1
fi

vInput="$1"

if [ ! -f "$vInput" ]; then
  echo "Error: '$vInput' no existe." >&2
  exit 1
fi

grep -q '{' "$vInput" || { echo "Error: entrada sin JSON." >&2; exit 1; }

# Emitir cabecera HTML
cat <<EOF
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="utf-8">
<title>Dispositivos conectados por interfaz</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
  body { font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif; margin: 20px; }
  h2 { margin: 28px 0 10px; font-size: 18px; }
  .ifcard { border: 1px solid #ddd; border-radius: 10px; padding: 14px; box-shadow: 0 1px 3px rgba(0,0,0,.06); margin-bottom: 20px; }
  table { width: 100%; border-collapse: collapse; font-size: 14px; }
  th, td { padding: 8px 10px; border-bottom: 1px solid #eee; text-align: left; white-space: nowrap; }
  th { background: #f7f7f7; position: sticky; top: 0; }
  .hostname { font-weight: 600; }
  .wrap { white-space: normal; }
  .muted { color: #666; }
</style>
</head>
<body>
<h1>Informe de dispositivos conectados por interfaz ($(date +"a%Ym%md%dh%Hm%Ms%S"))</h1>
EOF

# Generar HTML agrupado correctamente
jq -r '
  to_entries[]
  | (
      "<div class=\"ifcard\">\n" +
      "  <h2>" + .key + "</h2>\n" +
      "  <table><thead><tr><th>IP</th><th>MAC</th><th>Hostname</th><th>Fabricante</th></tr></thead><tbody>\n" +
      (
        .value
        | map(
            "    <tr><td>" + (.ip // "-") + "</td><td class=\"muted\">" + (.mac // "-") +
            "</td><td class=\"hostname\">" + (.hostname // "-") +
            "</td><td class=\"wrap\">" + (.fabricante // "-") + "</td></tr>\n"
          )
        | join("")
      ) +
      "  </tbody></table></div>\n"
    )
' "$vInput"

# Cierre HTML
cat <<EOF
</body></html>
EOF
